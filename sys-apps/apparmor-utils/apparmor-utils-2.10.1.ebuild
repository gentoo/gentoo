# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )
inherit perl-module python-r1 versionator

DESCRIPTION="Additional userspace utils to assist with AppArmor profile management"
HOMEPAGE="http://apparmor.net/"
SRC_URI="https://launchpad.net/apparmor/$(get_version_component_range 1-2)/${PV}/+download/apparmor-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	~sys-libs/libapparmor-${PV}[perl,python]
	~sys-apps/apparmor-${PV}
	dev-perl/Locale-gettext
	dev-perl/RPC-XML
	dev-perl/TermReadKey
	virtual/perl-Data-Dumper
	virtual/perl-Getopt-Long"

S=${WORKDIR}/apparmor-${PV}/utils

PATCHES=(
	"${FILESDIR}/${PN}-2.10-shebang.patch"
)

src_compile() {
	python_setup

	# launches non-make subprocesses causing "make jobserver unavailable"
	# error messages to appear in generated code
	emake -j1
}

src_install() {
	perl_set_version
	emake DESTDIR="${D}" PERLDIR="${D}/${VENDOR_LIB}/Immunix" \
		VIM_INSTALL_PATH="${D}/usr/share/vim/vimfiles/syntax" install

	install_python() {
		"${PYTHON}" "${S}"/python-tools-setup.py install --prefix=/usr \
			--root="${D}" --version="${PV}"
	}

	python_foreach_impl install_python
	python_replicate_script "${D}"/usr/bin/aa-easyprof "${D}"/usr/sbin/apparmor_status \
		"${D}"/usr/sbin/aa-{audit,autodep,cleanprof,complain,disable,enforce,genprof,logprof,mergeprof,status,unconfined}
}
