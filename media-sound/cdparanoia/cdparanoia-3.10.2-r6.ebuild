# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils libtool toolchain-funcs versionator multilib-minimal

MY_P=${PN}-III-$(get_version_component_range 2-3)
DESCRIPTION="an advanced CDDA reader with error correction"
HOMEPAGE="http://www.xiph.org/paranoia"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${MY_P}.src.tgz
	https://dev.gentoo.org/~ssuominen/${MY_P}-patches-2.tbz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="app-eselect/eselect-cdparanoia
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224-r4
					!app-emulation/emul-linux-x86-soundlibs[-abi_x86_32(-)] )"
DEPEND=${RDEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patches

	mv configure.guess config.guess
	mv configure.sub config.sub

	sed -i -e '/configure.\(guess\|sub\)/d' configure.in || die

	eautoconf
	elibtoolize

	multilib_copy_sources
}

multilib_src_configure() {
	tc-export AR CC RANLIB
	econf
}

multilib_src_compile() {
	emake OPT="${CFLAGS} -I${S}/interface"
	use static-libs && emake lib OPT="${CFLAGS} -I${S}/interface"
}

multilib_src_install_all() {
	einstalldocs
	mv "${ED}"/usr/bin/${PN}{,-paranoia}
}

pkg_postinst() {
	eselect ${PN} update ifunset
}

pkg_postrm() {
	eselect ${PN} update ifunset
}
