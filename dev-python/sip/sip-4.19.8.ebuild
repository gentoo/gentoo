# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit python-r1 toolchain-funcs

DESCRIPTION="Python extension module generator for C and C++ libraries"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/intro"

if [[ ${PV} == *9999 ]]; then
	inherit mercurial
	EHG_REPO_URI="https://www.riverbankcomputing.com/hg/sip"
elif [[ ${PV} == *_pre* ]]; then
	MY_P=${P/_pre/.dev}
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
else
	SRC_URI="mirror://sourceforge/pyqt/${P}.tar.gz"
fi

# Sub-slot based on SIP_API_MAJOR_NR from siplib/sip.h.in
SLOT="0/12"
LICENSE="|| ( GPL-2 GPL-3 SIP )"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
if [[ ${PV} == *9999 ]]; then
	DEPEND+="
		sys-devel/bison
		sys-devel/flex
		doc? ( dev-python/sphinx[$(python_gen_usedep 'python2*')] )"
fi

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
if [[ ${PV} == *9999 ]]; then
	REQUIRED_USE+=" || ( $(python_gen_useflags 'python2*') )"
fi

PATCHES=( "${FILESDIR}"/${PN}-4.18-darwin.patch )

src_prepare() {
	if [[ ${PV} == *9999 ]]; then
		python_setup 'python2*'
		"${PYTHON}" build.py prepare || die
		if use doc; then
			"${PYTHON}" build.py doc || die
		fi
	fi

	# Sub-slot sanity check
	local sub_slot=${SLOT#*/}
	local sip_api_major_nr=$(sed -nre 's:^#define SIP_API_MAJOR_NR\s+([0-9]+):\1:p' siplib/sip.h.in)
	if [[ ${sub_slot} != ${sip_api_major_nr} ]]; then
		eerror
		eerror "Ebuild sub-slot (${sub_slot}) does not match SIP_API_MAJOR_NR (${sip_api_major_nr})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${sip_api_major_nr}\""
		eerror
		die "sub-slot sanity check failed"
	fi

	default
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			--bindir="${EPREFIX}/usr/bin"
			--destdir="$(python_get_sitedir)"
			--incdir="$(python_get_includedir)"
			$(usex debug --debug '')
			AR="$(tc-getAR) cqs"
			CC="$(tc-getCC)"
			CFLAGS="${CFLAGS}"
			CFLAGS_RELEASE=
			CXX="$(tc-getCXX)"
			CXXFLAGS="${CXXFLAGS}"
			CXXFLAGS_RELEASE=
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			LFLAGS="${LDFLAGS}"
			LFLAGS_RELEASE=
			RANLIB=
			STRIP=
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	einstalldocs
	use doc && dodoc -r doc/html
}
