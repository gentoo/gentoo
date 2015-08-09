# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib toolchain-funcs

S_DATE="20130819"

DESCRIPTION="Open Settlement Protocol development kit"
HOMEPAGE="http://www.transnexus.com/OSP%20Toolkit/OSP%20Toolkit%20Documents/OSP%20Toolkit%20Documents.htm"
SRC_URI="mirror://sourceforge/osp-toolkit/OSPToolkit-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/TK-${PV//./_}-${S_DATE}

# TODO:
# generate a shared lib

# NOTES:
# osptest isn't a test that can be used for src_test, it's part of the toolkit

src_prepare() {
	# remove -O and use users CFLAGS, see bug 241034
	sed -i -e "s/ -O//" -e "s/^CFLAGS =/CFLAGS +=/" src/Makefile test/Makefile \
		enroll/Makefile || die "patching Makefiles failed"

	# use users LDFLAGS
	sed -i -e "s:LFLAGS:LDFLAGS:" test/Makefile \
		|| die "patching test/Makefile failed"
	sed -i -e "s:\(\$(LIBS\):\$(LDFLAGS) \1:" enroll/Makefile \
		|| die "patching enroll/Makefile failed"

	# change lib dir to $(get_libdir)
	sed -i -e "s:\$(INSTALL_PATH)/lib:\$(INSTALL_PATH)/$(get_libdir):" \
		src/Makefile || die "patching src/Makefile failed"

	# test.cfg is located in /etc/${PN}/test.cfg
	sed -i -e \
		"s:\(^#define CONFIG_FILENAME.*\"\).*\(test.cfg\"\):\1/etc/${PN}/\2:" \
		test/test_app.c || die "patching test/test_app.c failed"

	# configure enroll.sh
	sed -i -e "s:^\(OPENSSL_CONF\).*:\1=/etc/${PN}/openssl.cnf:" \
		-e "s:^\(RANDFILE\).*:\1=\/etc/${PN}/.rnd:" \
		bin/enroll.sh || die "patching bin/enroll.sh failed"

	# change enroll path
	sed -i -e "s:^\(enroll\):/usr/lib/${PN}/\1:" \
		bin/enroll.sh || die "patching bin/enroll.sh failed"
}

src_compile() {
	local my_cc=$(tc-getCC)

	emake -C src CC="${my_cc}" build || die "emake libosp failed"
	emake -C enroll CC="${my_cc}" linux || die "emake enroll failed"
	emake -C test CC="${my_cc}" linux || die "emake test failed"
}

src_install() {
	local ospdir="/usr/$(get_libdir)/${PN}"

	emake -C src INSTALL_PATH="${D}"/usr install || die "emake install failed"

	insinto /etc/${PN}
	doins bin/test.cfg bin/.rnd bin/openssl.cnf || die "doins failed"

	# install enroll and enroll.sh in lib dir to prevent executing them
	dodir ${ospdir}
	exeinto ${ospdir}
	doexe bin/enroll bin/enroll.sh || die "doexe failed"

	# use the symlink to execute enroll.sh
	dosym ${ospdir}/enroll.sh /usr/bin/ospenroll || die "dosym failed"

	newbin bin/test_app osptest || die "newbin failed"

	dodoc README.txt RELNOTES.txt || die "dodoc failed"
}

pkg_postinst() {
	elog "OSP test application is now available with 'osptest' command"
	elog "OSP enroll application is now available with 'ospenroll' command"
	elog "ospenroll is using /etc/${PN}/openssl.cnf as an openssl configuration"
}
