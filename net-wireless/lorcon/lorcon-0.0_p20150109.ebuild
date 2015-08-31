# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

USE_RUBY="ruby19 ruby20"
RUBY_OPTIONAL=yes

inherit distutils-r1 ruby-ng

DESCRIPTION="A generic library for injecting 802.11 frames"
HOMEPAGE="http://802.11ninja.net/lorcon"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://code.google.com/p/lorcon/"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="amd64 arm ~ppc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="python ruby"

DEPEND="ruby? ( $(ruby_implementations_depend) )
	python? ( ${PYTHON_DEPS} )
	dev-libs/libnl:3=
	net-libs/libpcap"
RDEPEND="${DEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}"/${P}

pkg_setup() {
	use ruby && ruby-ng_pkg_setup
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-r3_src_unpack
		cp -R "${S}/" "${WORKDIR}/all"
	fi
	default_src_unpack
	#ruby-ng_src_unpack doesn't seem to like mixing with git so we just copy things above
	use ruby && ruby-ng_src_unpack
}

src_prepare() {
	sed -i 's#<lorcon2/lorcon.h>#"../lorcon.h"#' pylorcon2/PyLorcon2.c
	sed -i 's#find_library("orcon2", "lorcon_list_drivers", "lorcon2/lorcon.h") and ##' ruby-lorcon/extconf.rb
	sed -i 's#<lorcon2/lorcon.h>#"../lorcon.h"#' ruby-lorcon/Lorcon2.h
	use python && distutils-r1_src_prepare
	use ruby && ruby-ng_src_prepare
}

src_configure() {
	default_src_configure
}

src_compile() {
	default_src_compile
	use ruby && ruby-ng_src_compile
	if use python; then
		LDFLAGS+=" -L${S}/.libs/"
		cd pylorcon2 || die
		distutils-r1_src_compile
	fi
}

src_install() {
	emake DESTDIR="${ED}" install
	use ruby && ruby-ng_src_install
	if use python; then
		cd pylorcon2 || die
		distutils-r1_src_install
	fi
}

src_test() {
	:
}

each_ruby_compile() {
	sed -i "s#-I/usr/include/lorcon2#-I${WORKDIR}/${P}/ruby-lorcon -L${WORKDIR}/${P}/.libs#" ruby-lorcon/extconf.rb
	"${RUBY}" -C ruby-lorcon extconf.rb || die
	sed -i 's#<lorcon2/lorcon.h>#"../lorcon.h"#' ruby-lorcon/Lorcon2.h
	sed -i "s#-L\.#-L. -L${WORKDIR}/${P}/.libs -lorcon2 #g" ruby-lorcon/Makefile || die
	emake -C ruby-lorcon
}

each_ruby_install() {
	DESTDIR="${ED}" emake -C ruby-lorcon install
}
