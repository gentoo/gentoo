# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sip/sip-4.16.9.ebuild,v 1.1 2015/07/22 03:21:29 pesa Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils python-r1 toolchain-funcs

DESCRIPTION="Python extension module generator for C and C++ libraries"
HOMEPAGE="http://www.riverbankcomputing.com/software/sip/intro https://pypi.python.org/pypi/SIP"
LICENSE="|| ( GPL-2 GPL-3 SIP )"

if [[ ${PV} == *9999* ]]; then
	# live version from mercurial repo
	EHG_REPO_URI="http://www.riverbankcomputing.com/hg/sip"
	inherit mercurial
elif [[ ${PV} == *_pre* ]]; then
	# development snapshot
	HG_REVISION=
	MY_P=${PN}-${PV%_pre*}-snapshot-${HG_REVISION}
	SRC_URI="http://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
else
	# official release
	SRC_URI="http://www.riverbankcomputing.com/static/Downloads/sip4/${P}.tar.gz"
fi

# Sub-slot based on SIP_API_MAJOR_NR from siplib/sip.h.in
SLOT="0/11"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug doc"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

[[ ${PV} == *9999* ]] && DEPEND+="
	=dev-lang/python-2*
	sys-devel/bison
	sys-devel/flex
	doc? ( dev-python/sphinx[$(python_gen_usedep 'python2*')] )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.15.5-darwin.patch

	if [[ ${PV} == *9999* ]]; then
		python2 build.py prepare || die
		if use doc; then
			python2 build.py doc || die
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
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			--destdir="$(python_get_sitedir)"
			--incdir="$(python_get_includedir)"
			$(use debug && echo --debug)
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

	dodoc ChangeLog NEWS
	use doc && dodoc -r doc/html
}
