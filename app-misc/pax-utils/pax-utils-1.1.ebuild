# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs unpacker

DESCRIPTION="ELF related utils for ELF 32/64 binaries that can check files for security relevant properties"
HOMEPAGE="https://wiki.gentoo.org/index.php?title=Project:Hardened/PaX_Utilities"
SRC_URI="mirror://gentoo/pax-utils-${PV}.tar.xz
	http://dev.gentoo.org/~solar/pax/pax-utils-${PV}.tar.xz
	http://dev.gentoo.org/~vapier/dist/pax-utils-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="caps python seccomp"

RDEPEND="caps? ( sys-libs/libcap )
	python? ( dev-python/pyelftools )
	seccomp? ( sys-libs/libseccomp )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

_emake() {
	emake \
		USE_CAP=$(usex caps) \
		USE_PYTHON=$(usex python) \
		USE_SECCOMP=$(usex seccomp) \
		"$@"
}

src_configure() {
	# Avoid slow configure+gnulib+make if on an up-to-date Linux system
	if use prefix || ! use kernel_linux || \
	   has_version '<sys-libs/glibc-2.10'
	then
		econf $(use_with caps) $(use_with python) $(use_with seccomp)
	else
		tc-export CC
	fi
}

src_compile() {
	_emake
}

src_test() {
	_emake check
}

src_install() {
	_emake DESTDIR="${ED}" PKGDOCDIR='$(DOCDIR)'/${PF} install
}
