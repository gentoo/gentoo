# Here we remove any ABI that isn't native.
case ${ARCH} in
	mips)
		# Both n32 and n64 are 64-bit kernel and userland.
		# n64 is 64-bit pointers/long
		# n32 is 32-bit pointers/long
		case ${USE} in
			n32)
				export CFLAGS="${CFLAGS/-mabi=*/-mabi=n32}"
				export CXXFLAGS="${CFLAGS}"
				;;
			n64)
				export CFLAGS="${CFLAGS/-mabi=*/-mabi=64}"
				export CXXFLAGS="${CFLAGS}"
				;;
		esac
		;;
esac
