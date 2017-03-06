hostprogs-y	:= mdp
HOST_EXTRACFLAGS += \
	-I$(srctree)/include/uapi -I$(srctree)/include \
	-I$(srctree)/security/selinux/include

always		:= $(hostprogs-y)
clean-files	:= $(hostprogs-y) policy.* file_contexts
