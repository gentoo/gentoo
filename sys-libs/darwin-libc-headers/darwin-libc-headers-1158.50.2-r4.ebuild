# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

IPV=503.50.4
CPV=60092.50.5
MPV=116.50.8
PPV=218.60.3
LPV=126.50.8
UPV=35.3
OPV=67
DPV=433.5
APV=703.50.37
FPV=138
OSX=10.12
DESCRIPTION="Darwin system headers from Libc ${PV}, macOS ${OSX}.6"
HOMEPAGE="https://opensource.apple.com/source/Libc"
SRC_URI="https://opensource.apple.com/tarballs/Libc/Libc-${PV}.tar.gz
	https://opensource.apple.com/tarballs/Libinfo/Libinfo-${IPV}.tar.gz
	https://opensource.apple.com/tarballs/CommonCrypto/CommonCrypto-${CPV}.tar.gz
	https://opensource.apple.com/tarballs/libmalloc/libmalloc-${MPV}.tar.gz
	https://opensource.apple.com/tarballs/libpthread/libpthread-${PPV}.tar.gz
	https://opensource.apple.com/tarballs/libplatform/libplatform-${LPV}.tar.gz
	https://opensource.apple.com/tarballs/libunwind/libunwind-${UPV}.tar.gz
	https://opensource.apple.com/tarballs/libclosure/libclosure-${OPV}.tar.gz
	https://opensource.apple.com/tarballs/libdispatch/libdispatch-${APV}.tar.gz
	https://opensource.apple.com/tarballs/copyfile/copyfile-${FPV}.tar.gz
	https://opensource.apple.com/tarballs/dyld/dyld-${DPV}.tar.gz
	https://dev.gentoo.org/~grobian/distfiles/${PN}-${OSX}-r2.tar.gz"

LICENSE="APSL-2"
SLOT="${OSX}"
KEYWORDS="~x64-macos"
IUSE="+man"

BDEPEND="sys-apps/darwin-miscutils"

S=${WORKDIR}/Libc-${PV}

src_prepare() {
	default

	# convert BSD find to GNU find syntax
	sed -i \
		-e 's/find -E ${SRCROOT}/find ${SRCROOT} -regextype posix-extended/' \
		xcodescripts/manpages.sh || die
	chmod 755 xcodescripts/manpages.sh || die

	# drop ownership stuff and use soft-links
	sed -i \
		-e 's/-o "$INSTALL_OWNER" -g "$INSTALL_GROUP"//' \
		-e 's/ln -hf/ln -sf/' \
		"${WORKDIR}"/Libinfo-${IPV}/xcodescripts/install_files.sh \
		"${WORKDIR}"/copyfile-${FPV}/xcodescripts/install_files.sh || die

	# add libmalloc manpage stuff to Libc to automate the installation
	cp "${WORKDIR}"/libmalloc-${MPV}/man/*.3 man/ || die
	cat "${WORKDIR}"/libmalloc-${MPV}/man/manpages.lst \
		>> man/manpages.lst || die

	# produce softlinks when installing libpthread manpages, don't do
	# ownership or /usr/local stuff
	sed -i \
		-e 's/ln -fh/ln -fs/' \
		-e '/chmod/d' -e '/chown/d' \
		-e '/\/usr\/local\/share/d' \
		"${WORKDIR}"/libpthread-${PPV}/xcodescripts/install-manpages.sh || die
}

src_compile() {
	: ;  # nothing to do
}

src_install() {
	run_xcode_ish() {
		env ARCHS="x86_64 i386" \
			PLATFORM_NAME=macosx \
			VARIANT_PLATFORM_NAME=macosx \
			DERIVED_FILES_DIR="${T}" \
			SRCROOT="${S}" \
			DSTROOT="${ED}" \
			PUBLIC_HEADERS_FOLDER_PATH="/usr/include" \
			PRIVATE_HEADERS_FOLDER_PATH="remove-me" \
			"${BASH}" "$@"
	}

	run_xcode_ish ./xcodescripts/headers.sh || die
	if use man ; then
		run_xcode_ish ./xcodescripts/manpages.sh || die
		for f in "${ED}"/usr/share/man/man*/* ; do
			[[ -e ${f} ]] || rm "${f}"
		done
	fi

	pushd "${WORKDIR}"/Libinfo-${IPV} > /dev/null || die
	run_xcode_ish ./xcodescripts/install_files.sh || die
	popd > /dev/null || die

	if use man ; then
		pushd "${WORKDIR}"/copyfile-${FPV} > /dev/null || die
		run_xcode_ish ./xcodescripts/install_files.sh || die
		popd > /dev/null || die
	fi

	insinto /usr/include
	doins -r "${WORKDIR}"/libmalloc-${MPV}/include/malloc
	doins -r "${WORKDIR}"/libpthread-${PPV}/pthread
	doins -r "${WORKDIR}"/libplatform-${LPV}/include/*
	doins -r "${WORKDIR}"/libunwind-${UPV}/include/*
	doins -r "${WORKDIR}"/${PN}-${OSX}/include/*
	doins "${WORKDIR}"/libclosure-${OPV}/Block.h
	doins "${WORKDIR}"/dyld-${DPV}/include/dlfcn.h
	doins "${WORKDIR}"/copyfile-${FPV}/copyfile.h \
		"${WORKDIR}"/copyfile-${FPV}/xattr_flags.h

	insinto /usr/include/sys
	doins "${WORKDIR}"/libpthread-${PPV}/sys/qos.h
	doins -r "${WORKDIR}"/libpthread-${PPV}/sys/_pthread

	insinto /usr/include/mach-o
	doins "${WORKDIR}"/dyld-${DPV}/include/mach-o/dyld{,_images}.h

	insinto /usr/include/CommonCrypto
	doins "${WORKDIR}"/CommonCrypto-${CPV}/include/CommonCrypto.h \
		"${WORKDIR}"/CommonCrypto-${CPV}/include/CommonCryptoError.h \
		"${WORKDIR}"/CommonCrypto-${CPV}/include/CommonCryptor.h \
		"${WORKDIR}"/CommonCrypto-${CPV}/include/CommonDigest.h \
		"${WORKDIR}"/CommonCrypto-${CPV}/include/CommonHMAC.h \
		"${WORKDIR}"/CommonCrypto-${CPV}/include/CommonKeyDerivation.h \
		"${WORKDIR}"/CommonCrypto-${CPV}/include/CommonRandom.h \
		"${WORKDIR}"/CommonCrypto-${CPV}/include/CommonSymmetricKeywrap.h

	insinto /usr/include/dispatch
	doins "${WORKDIR}"/libdispatch-${APV}/dispatch/*.h \
		"${WORKDIR}"/libdispatch-${APV}/dispatch/darwin/module.modulemap
	insinto /usr/include/os
	doins "${WORKDIR}"/libdispatch-${APV}/os/object.h

	insinto /Frameworks
	doins -r "${WORKDIR}"/${PN}-${OSX}/Frameworks/*.framework

	run_xcode_ish \
		"${WORKDIR}"/libpthread-${PPV}/xcodescripts/install-symlinks.sh || die

	S="${WORKDIR}"/libpthread-${PPV} run_xcode_ish \
		"${WORKDIR}"/libpthread-${PPV}/xcodescripts/install-manpages.sh || die

	ln -s ../nameser.h "${ED}"/usr/include/arpa/nameser.h || die

	rm -Rf "${ED}"/remove-me "${ED}"/System "${ED}"/usr/local || die
	use man || rm -Rf "${ED}/usr/share/man"

	# drop conflicting header (db is antiquated)
	rm "${ED}"/usr/include/db.h || die
}
