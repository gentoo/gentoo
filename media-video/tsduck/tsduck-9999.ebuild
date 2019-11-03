# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The MPEG Transport Stream Toolkit"
HOMEPAGE="https://tsduck.io/"

EGIT_REPO_URI="https://github.com/tsduck/tsduck.git -> ${P}.tar.gz"
inherit git-r3
SRC_URI=""
DOCS=()

HTML_DOCS=( src )

SLOT="0"
LICENSE="BSD"

IUSE="+curl debug smartcard test"
DEPEND="
	curl? ( net-misc/curl )
	smartcard? ( sys-apps/pcsc-lite )
"
RDEPEND="${DEPEND}"

#src_configure() {
#    use static && append-ldflags -static
#    default
#}

src_compile() {
	# dektek only available for linux distro on X86 Intel CPU using gnu libc,
	# not making it available for now
	COMPILE_ARG="NODTAPI=1 "
	# Always use TELETEXT for now
	# use teletext || COMPILE_ARG+="NOTELETEXT=1 "

	use test || COMPILE_ARG+="NOTEST=1 "
	use debug && COMPILE_ARG+="DEBUG=1 "
	use curl || COMPILE_ARG+="NOCURL=1 "
	use smartcard || COMPILE_ARG+="NOPCSC=1 "

	emake ${COMPILE_ARG}
}

src_install() {
	DEBUG_ARG=""
	use debug && DEBUG_ARG+="DEBUG=1"
	# emake DESTDIR="${D}" ${DEBUG_ARG} install
	# TSDuck uses SYSPREFIX instead of DESTDIR
	emake SYSPREFIX="${D}" ${DEBUG_ARG} install
	einstalldocs
}

src_test() {
	use test && emake test
}
