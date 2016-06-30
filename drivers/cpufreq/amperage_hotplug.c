/* Copyright (c) 2016 Joe Maples <joe@frap129.org>
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * A power biased hotplug for hexacore big.LITTLE configurations
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/device.h>
#include <linux/cpu.h>
#include <linux/powersuspend.h>
#include <linux/cpufreq.h>
#include <linux/sched.h>
#include <linux/delay.h>

#define AMPERAGE "amperage"
#define DEFAULT_PLUGGING_THRESHOLD 1497600000
#define DEFAULT_SUSPEND_CHECK_RATE 10000


static inline void __cpuinit core_handling(bool suspended, int freq0, int freq1, int freq4)
{
	unsigned int plugging_threshold = DEFAULT_PLUGGING_THRESHOLD;
//	module_param(plugging_threshold, int, 0644);

	if(suspended){
		if (cpu_online(5))
                        cpu_down(5);
		if (cpu_online(4))
			cpu_down(4);
		if (freq0 >= plugging_threshold) {
			cpu_up(1);
			return;
		} else {
			if (cpu_online(1))
        	                cpu_down(1);
				return;
		}
	} else {
		if (!cpu_online(1) && freq0 >= plugging_threshold) {
			cpu_up(1);
			return;
		} else {
			cpu_down(1);
			return;
		}
		if (!cpu_online(4) && freq1 >= plugging_threshold) {
			cpu_down(1);
			cpu_up(4);
			return;
		} else {
			cpu_down(4);
			return;
		}

		if (cpu_online(4) && freq4 >= plugging_threshold) {
			cpu_up(5);
			return;
		} else {
			cpu_down(5);
			return;
		}
	}
}

static void amperage_main(void)
{
	unsigned int suspend_check_rate = DEFAULT_SUSPEND_CHECK_RATE;
//	module_param(suspend_check_rate, int, 0644);
	int curfreq0 = cpufreq_get(0);
	int curfreq1 = cpufreq_get(1);
	int curfreq4 = cpufreq_get(4);
	while(power_suspended) {
		core_handling(false, curfreq0, curfreq1, curfreq4);
		msleep(suspend_check_rate);
	}
	while(!power_suspended) {
		core_handling(false, curfreq0, curfreq1, curfreq4);
                       msleep(suspend_check_rate);
	}
}
static int __init start_amperage(void)
{
	pr_info("%s: init\n", AMPERAGE);
	amperage_main();
	return 0;
}

static void __exit exit_amperage(void)
{
	return;
}

MODULE_LICENSE("GPL and additional rights");
MODULE_AUTHOR("Joe Maples <joe@frap129.org");
MODULE_DESCRIPTION("A simple screen-based hotplugging driver for the Nexus 6P");
late_initcall(start_amperage);
module_exit(exit_amperage);
