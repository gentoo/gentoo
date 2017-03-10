# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit python-r1 toolchain-funcs

DESCRIPTION="Python extension module generator for C and C++ libraries"
HOMEPAGE="https://www.riverbankcomputing.com/software/sip/intro"
SRC_URI="mirror://sourceforge/pyqt/${P}.tar.gz"

# Sub-slot based on SIP_API_MAJOR_NR from siplib/sip.h.in
SLOT="0/11"
LICENSE="|| ( GPL-2 GPL-3 SIP )"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

PATCHES=( "${FILESDIR}"/${PN}-4.18-darwin.patch )

src_prepare() {
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

	# Fix out-of-source installation of sip.pyi (reported upstream)
	sed -i -e '/installs.*sip\.pyi/ s/build_dir/src_dir/' configure.py || die

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
