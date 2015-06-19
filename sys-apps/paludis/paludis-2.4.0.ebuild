# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/paludis/paludis-2.4.0.ebuild,v 1.1 2015/04/04 17:54:43 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
# matching profile defaults for now
RUBY_VER=2.0

inherit autotools bash-completion-r1 eutils python-single-r1 user

DESCRIPTION="paludis, the other package mangler"
HOMEPAGE="http://paludis.exherbo.org/"
SRC_URI="http://paludis.exherbo.org/download/${P}.tar.bz2"

IUSE="doc pbins pink python ruby search-index test xml"
LICENSE="GPL-2 vim"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

COMMON_DEPEND="
	>=app-admin/eselect-1.2.13
	>=app-shells/bash-3.2
	dev-libs/libpcre[cxx]
	sys-apps/file
	pbins? ( >=app-arch/libarchive-3.1.2 )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/boost-1.41.0[python,${PYTHON_USEDEP}] )
	ruby? ( dev-lang/ruby:${RUBY_VER} )
	search-index? ( >=dev-db/sqlite-3 )
	xml? ( >=dev-libs/libxml2-2.6 )"

DEPEND="${COMMON_DEPEND}
	>=app-text/asciidoc-8.6.3
	app-text/htmltidy
	app-text/xmlto
	>=sys-devel/gcc-4.7
	doc? (
		|| (
			>=app-doc/doxygen-1.5.3
			<=app-doc/doxygen-1.5.1 )
		python? (
		dev-python/sphinx[${PYTHON_USEDEP}] )
		ruby? ( dev-ruby/syntax[ruby_targets_ruby${RUBY_VER/./}] )
	)
	virtual/pkgconfig
	test? ( >=dev-cpp/gtest-1.6.0-r1 )"

RDEPEND="${COMMON_DEPEND}
	sys-apps/sandbox"

PDEPEND="app-eselect/eselect-package-manager"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

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

	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(gcc-major-version) -lt 4
			|| ( $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ) ]]
		then
			eerror "Paludis requires at least gcc 4.7 to build. Please switch the active"
			eerror "gcc version using gcc-config."
			die "Paludis requires at least gcc 4.7"
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

	epatch_user
}

src_configure() {
	local myconf=(
		--htmldir=/usr/share/doc/${PF}/html

		$(use_enable doc doxygen)
		$(use_enable test gtest)
		$(use_enable pbins)
		$(use_enable pink)
		$(use_enable python)
		$(use python && use_enable doc python-doc)
		$(use_enable ruby)
		$(use ruby && use_enable doc ruby-doc)
		--with-ruby-version="${RUBY_VER}"
		$(use_enable search-index)
		$(use_enable xml)

		--enable-vim
		--with-config-framework=eselect
		--with-environments=default,portage
		--with-vim-install-dir=/usr/share/vim/vimfiles
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	prune_libtool_files

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

	if ! nonfatal emake -k check ; then
		eerror "Tests failed. Looking for files for you to add to your bug report..."
		find "${S}" -type f -name '*.epicfail' -or -name '*.log' | while read a ; do
			eerror "    $a"
		done
		die "Make check failed"
	fi
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
