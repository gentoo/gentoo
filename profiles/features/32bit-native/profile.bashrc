# Here we die on any arch that isn't 32-bit.
case ${ARCH} in
	amd64) die "This architecture always uses a 64-bit kernel. Please use an x86 profile!" ;;
	mips) die "This architecture always uses a 64-bit kernel." ;;
	ppc64) die "This architecture always uses a 64-bit kernel. Please use a ppc profile!" ;;
	sparc) die "This architecture always uses a 64-bit kernel." ;;
esac
