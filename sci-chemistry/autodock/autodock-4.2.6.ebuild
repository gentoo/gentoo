# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Tests require python2
#PYTHON_COMPAT=( python2_7 )

inherit autotools readme.gentoo-r1 #python-any-r1

MY_PN="autodocksuite"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A suite of automated docking tools"
HOMEPAGE="http://autodock.scripps.edu/"
SRC_URI="http://autodock.scripps.edu/downloads/autodock-registration/tars/dist$(ver_rs 1- '')/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples openmp" #test
#RESTRICT="!test? ( test )"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

RDEPEND=""
DEPEND=""
#DEPEND="test? ( ${PYTHON_DEPS} )"

S="${WORKDIR}/src"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
The AutoDock development team requests all users to fill out the
registration form at:

http://autodock.scripps.edu/downloads/autodock-registration

The number of unique users of AutoDock is used by Prof. Arthur J.
Olson and the Scripps Research Institude to support grant
applications.
"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch
)

src_prepare() {
	default

	local i

	sed \
		-e "s/\tcsh/\tsh/" \
		-i auto{dock,grid}/Makefile.am || die
	for i in autodock autogrid; do
		pushd $i &>/dev/null
		eautoreconf
		popd &>/dev/null
	done
}

src_configure() {
	local i
	for i in autodock autogrid; do
		pushd $i &>/dev/null
		econf $(use_enable openmp)
		popd &>/dev/null
	done
}

src_compile() {
	emake -C autodock
	emake -C autogrid
}

#src_test() {
#	elog "Testing autodock"
#	cd "${S}/autodock/Tests" || die
#	cp ../*.dat . || die
#	${EPYTHON} test_autodock4.py || die "AutoDock tests failed."
#	einfo "Testing autogrid"
#	cd "${S}/autogrid/Tests" || die
#	${EPYTHON} test_autogrid4.py || die "AutoGrid tests failed."
#}

src_install() {
	if use openmp; then
		newbin autodock/autodock4.omp ${PN}4
		dobin autogrid/autogrid4
	else
		dobin autodock/autodock4 autogrid/autogrid4
	fi

	insinto /usr/share/${PN}
	doins -r \
		autodock/{AD4_parameters.dat,AD4_PARM99.dat} \
		$(usex examples "autodock/EXAMPLES" "")

	DOCS=(
		RELEASENOTES
		autodock/{AUTHORS,README}
		autodock/USERGUIDES/AutoDock4.{0,1,2}_UserGuide.doc
		autodock/USERGUIDES/AutoDock4.2_UserGuide.pdf
	)
	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
