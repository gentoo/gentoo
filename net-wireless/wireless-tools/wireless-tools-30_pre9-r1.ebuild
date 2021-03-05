# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs multilib eutils

# The following works with both pre-releases and releases
MY_P=${PN/-/_}.${PV/_/.}
S="${WORKDIR}/${MY_P/\.pre*/}"

DESCRIPTION="A collection of tools to configure IEEE 802.11 wireless LAN cards"
HOMEPAGE="http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html"
SRC_URI="http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86"
IUSE="multicall"

DEPEND="sys-apps/sed"
RDEPEND=""

PATCHES=("${FILESDIR}"/${PN}-29-asneeded.patch)

src_prepare() {
	default

	sed -i \
		-e "s:^\(CC\) = gcc:\1 = $(tc-getCC):" \
		-e "s:^\(AR\) = ar:\1 = $(tc-getAR):" \
		-e "s:^\(RANLIB\) = ranlib:\1 = $(tc-getRANLIB):" \
		-e "s:^\(CFLAGS=-Os\):#\1:" \
		-e "s:\(@\$(LDCONFIG).*\):#\1:" \
		-e "s:^\(INSTALL_MAN= \$(PREFIX)\)/man:\1/usr/share/man:" \
		-e "s:^\(INSTALL_LIB= \$(PREFIX)\)/lib:\1/$(get_libdir)/:" \
		-e "s:^\(INSTALL_INC= \$(PREFIX)\)/include:\1/usr/include:" \
		-e "s:^\(BUILD_STATIC = y\):#\1:" \
		-e '/\$(CC)/s:-Wl,-s\>::' \
		"${S}"/Makefile || die
}

src_compile() {
	emake

	use multicall && emake iwmulticall
}

src_install() {
	emake PREFIX="${ED}" install

	if use multicall; then
		# 'make install-iwmulticall' will overwrite some of the tools
		# with symlinks - this is intentional (brix)
		emake PREFIX="${ED}" install-iwmulticall
	fi

	has cs ${LINGUAS-cs} || rm -rf "${ED}"/usr/share/man/cs
	has fr ${LINGUAS-fr} || rm -rf "${ED}"/usr/share/man/fr.{ISO8859-1,UTF-8}

	dodoc CHANGELOG.h HOTPLUG-UDEV.txt IFRENAME-VS-XXX.txt PCMCIA.txt README
	has fr ${LINGUAS-fr} && dodoc README.fr
}
