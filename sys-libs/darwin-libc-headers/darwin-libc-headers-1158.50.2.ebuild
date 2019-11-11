# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MPV=116.50.8
DESCRIPTION="Darwin system headers from Libc ${PV}, macOS 10.12.6"
HOMEPAGE="https://opensource.apple.com/source/Libc"
SRC_URI="https://opensource.apple.com/tarballs/Libc/Libc-${PV}.tar.gz
	https://opensource.apple.com/tarballs/libmalloc/libmalloc-${MPV}.tar.gz"

LICENSE="APSL-2"
SLOT="10.12"
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

	# add libmalloc manpage stuff to Libc to automate the installation
	cp "${WORKDIR}"/libmalloc-${MPV}/man/*.3 man/ || die
	cat "${WORKDIR}"/libmalloc-${MPV}/man/manpages.lst \
		>> man/manpages.lst || die
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
			"$@"
	}

	run_xcode_ish ./xcodescripts/headers.sh || die
	if use man ; then
		run_xcode_ish ./xcodescripts/manpages.sh || die
	fi

	insinto /usr/include
	doins -r "${WORKDIR}"/libmalloc-${MPV}/include/malloc

	rm -Rf "${ED}"/remove-me "${ED}"/System || die
}
