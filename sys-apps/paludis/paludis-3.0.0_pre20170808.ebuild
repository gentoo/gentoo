# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
RUBY_VER=2.3

inherit bash-completion-r1 cmake-utils python-single-r1 user

MY_P=paludis-f8e58ee1d02d2476ae92ebc3737e42b8b6a36891
DESCRIPTION="paludis, the other package mangler"
HOMEPAGE="http://paludis.exherbo.org/"
SRC_URI="https://git.exherbo.org/paludis/paludis.git/snapshot/${MY_P}.tar.xz"

IUSE="doc pbins pink python ruby ruby_targets_ruby${RUBY_VER/./} search-index test +xml"
LICENSE="GPL-2 vim"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

COMMON_DEPEND="
	>=app-admin/eselect-1.2.13
	>=app-shells/bash-3.2:0
	dev-libs/libpcre:=[cxx]
	sys-apps/file:=
	pbins? ( >=app-arch/libarchive-3.1.2:= )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/boost-1.41.0:=[python,${PYTHON_USEDEP}] )
	ruby? ( dev-lang/ruby:${RUBY_VER} )
	search-index? ( >=dev-db/sqlite-3:= )
	xml? ( >=dev-libs/libxml2-2.6:= )"

DEPEND="${COMMON_DEPEND}
	app-arch/xz-utils
	>=app-text/asciidoc-8.6.3
	app-text/htmltidy
	app-text/xmlto
	>=sys-devel/gcc-4.7
	doc? (
		app-doc/doxygen
		python? ( dev-python/sphinx[${PYTHON_USEDEP}] )
		ruby? ( dev-ruby/syntax[ruby_targets_ruby${RUBY_VER/./}] )
	)
	virtual/pkgconfig
	test? ( >=dev-cpp/gtest-1.6.0-r1 )"

RDEPEND="${COMMON_DEPEND}
	sys-apps/sandbox"

PDEPEND="app-eselect/eselect-package-manager"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	ruby? ( ruby_targets_ruby${RUBY_VER/./} )"
RESTRICT="!test? ( test )"

S=${WORKDIR}/${MY_P}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		if id paludisbuild >/dev/null 2>/dev/null ; then
			if ! groups paludisbuild | grep --quiet '\<tty\>' ; then
				eerror "The 'paludisbuild' user is now expected to be a member of the"
				eerror "'tty' group. You should add the user to this group before"
				eerror "upgrading Paludis."
				die "Please add paludisbuild to tty group"
			fi
		fi
	fi
}

pkg_setup() {
	enewgroup "paludisbuild"
	enewuser "paludisbuild" -1 -1 "/var/tmp/paludis" "paludisbuild,tty"

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Fix the script shebang on Ruby scripts.
	# https://bugs.gentoo.org/show_bug.cgi?id=439372#c2
	sed -i -e "1s/ruby/&${RUBY_VER/./}/" ruby/demos/*.rb || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_GTEST=$(usex test)
		-DENABLE_PBINS=$(usex pbins)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_PYTHON_DOCS=$(usex doc) # USE=python implicit
		-DENABLE_RUBY=$(usex ruby)
		-DENABLE_RUBY_DOCS=$(usex doc) # USE=ruby implicit
		-DENABLE_SEARCH_INDEX=$(usex search-index)
		-DENABLE_VIM=ON
		-DENABLE_XML=$(usex xml)

		-DPALUDIS_COLOUR_PINK=$(usex pink)
		-DRUBY_VERSION=${RUBY_VER}
		-DPALUDIS_ENVIRONMENTS=all
		-DPALUDIS_DEFAULT_DISTRIBUTION=gentoo
		-DPALUDIS_CLIENTS=all
		-DCONFIG_FRAMEWORK=eselect

		# GNUInstallDirs
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dobashcomp bash-completion/cave

	insinto /usr/share/zsh/site-functions
	doins zsh-completion/_cave
}

src_test() {
	# Work around Portage bugs
	local -x PALUDIS_DO_NOTHING_SANDBOXY="portage sucks"
	local -x BASH_ENV=/dev/null

	if [[ ${EUID} == 0 ]] ; then
		# hate
		local -x PALUDIS_REDUCED_UID=0
		local -x PALUDIS_REDUCED_GID=0
	fi

	cmake-utils_src_test
}

pkg_postinst() {
	local pm
	if [[ -f ${ROOT}/etc/env.d/50package-manager ]] ; then
		pm=$( source "${ROOT}"/etc/env.d/50package-manager ; echo "${PACKAGE_MANAGER}" )
	fi

	if [[ ${pm} != paludis ]] ; then
		elog "If you are using paludis or cave as your primary package manager,"
		elog "you should consider running:"
		elog "    eselect package-manager set paludis"
	fi
}
