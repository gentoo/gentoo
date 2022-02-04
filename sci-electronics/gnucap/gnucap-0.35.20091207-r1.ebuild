# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs flag-o-matic

SNAPSHOTDATE="${P##*.}"
MY_PV="${PN}-${SNAPSHOTDATE:0:4}-${SNAPSHOTDATE:4:2}-${SNAPSHOTDATE:6:2}"

DESCRIPTION="GNUCap is the GNU Circuit Analysis Package"
SRC_URI="http://www.gnucap.org/devel/${MY_PV}.tar.gz
	http://www.gnucap.org/devel/${MY_PV}-models-bsim.tar.gz
	http://www.gnucap.org/devel/${MY_PV}-models-jspice3-2.5.tar.gz
	http://www.gnucap.org/devel/${MY_PV}-models-ngspice17.tar.gz
	http://www.gnucap.org/devel/${MY_PV}-models-spice3f5.tar.gz"
HOMEPAGE="http://www.gnucap.org/"

IUSE="examples"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"

# NOTE: readline could be made optional, but I don't see a point for now.
RDEPEND="sys-libs/readline:="
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PV}"

src_prepare() {
	# No need to install COPYING and INSTALL
	sed -i \
		-e 's: COPYING INSTALL::' \
		-e 's:COPYING history INSTALL:history:' \
		doc/Makefile.in || die

	if ! use examples ; then
		sed -i \
			-e 's:examples modelgen:modelgen:' \
			Makefile.in || die
	fi

	sed -i -e 's:CFLAGS = -O2 -g:CPPFLAGS +=:' \
		-e '/CCFLAGS =/i\CFLAGS += $(CPPFLAGS)' \
		-e 's:CCFLAGS = $(CFLAGS):CXXFLAGS += $(CPPFLAGS):' \
		-e 's:LDFLAGS = :LDFLAGS += :' \
		-e 's:CCFLAGS:CXXFLAGS:' \
		-e "s:../Gnucap:${S}/src:" \
		models-*/Make2 || die

	sed -i -e "s:strchr(str2, '|'):const_cast<char*>(strchr(str2, '|')):" \
		{src,modelgen}/ap_match.cc || die

	tc-export CC CXX
	append-cxxflags -std=gnu++98

	default
}

src_compile() {
	emake
	for PLUGIN_DIR in models-* ; do
		cd "${S}/${PLUGIN_DIR}"
		emake CC=$(tc-getCC) CCC=$(tc-getCXX)
	done
}

src_install() {
	emake DESTDIR="${D}" install
	insopts -m0755
	for PLUGIN_DIR in models-* ; do
		insinto /usr/$(get_libdir)/gnucap/${PLUGIN_DIR}
		cd "${S}/${PLUGIN_DIR}"
		for PLUGIN in */*.so ; do
			newins ${PLUGIN} ${PLUGIN##*/}
		done
	done
}

pkg_postinst() {
	elog "Documentation for development releases is now available at :"
	elog "    http://wiki.gnucap.org/dokuwiki/doku.php?id=gnucap:manual"
}
