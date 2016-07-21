# Here we remove any ABI that isn't 32-bit.
case ${PROFILE_ARCH} in
	mips64)
		# This is for o32 (64-bit kernel, 32-bit userland) so we force -mabi=32
		export CHOST="mips-unknown-linux-gnu"
		export CFLAGS="${CFLAGS/-mabi=*/-mabi=32}"
		export CXXFLAGS="${CFLAGS}"
		;;
esac
