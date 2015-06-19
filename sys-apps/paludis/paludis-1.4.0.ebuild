# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/paludis/paludis-1.4.0.ebuild,v 1.3 2015/03/31 18:24:09 ulm Exp $

inherit bash-completion-r1 eutils user

DESCRIPTION="paludis, the other package mangler"
HOMEPAGE="http://paludis.exherbo.org/"
SRC_URI="http://paludis.exherbo.org/download/${P}.tar.bz2"

IUSE="doc pbins portage pink prebuilt-documentation python-bindings ruby-bindings search-index test vim-syntax visibility xml zsh-completion"
LICENSE="GPL-2 vim-syntax? ( vim )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

COMMON_DEPEND="
	>=app-admin/eselect-1.2.13
	>=app-shells/bash-3.2
	>=sys-devel/gcc-4.4
	dev-libs/libpcre
	sys-apps/file
	pbins? ( >=app-arch/libarchive-3.1.2 )
	python-bindings? ( >=dev-lang/python-2.6 >=dev-libs/boost-1.41.0 )
	ruby-bindings? ( >=dev-lang/ruby-1.8 )
	xml? ( >=dev-libs/libxml2-2.6 )
	search-index? ( >=dev-db/sqlite-3 )"

DEPEND="${COMMON_DEPEND}
	!prebuilt-documentation? (
		>=app-text/asciidoc-8.6.3
		app-text/xmlto
	)
	doc? (
		|| ( >=app-doc/doxygen-1.5.3 <=app-doc/doxygen-1.5.1 )
		media-gfx/imagemagick
		python-bindings? ( dev-python/epydoc dev-python/pygments )
		ruby-bindings? ( dev-ruby/syntax )
	)
	virtual/pkgconfig
	test? ( >=dev-cpp/gtest-1.6.0-r1 )"

RDEPEND="${COMMON_DEPEND}
	sys-apps/sandbox"

# Keep syntax as a PDEPEND. It avoids issues when Paludis is used as the
# default virtual/portage provider.
PDEPEND="
	vim-syntax? ( >=app-editors/vim-core-7 )
	app-eselect/eselect-package-manager"

create-paludis-user() {
	enewgroup "paludisbuild"
	enewuser "paludisbuild" -1 -1 "/var/tmp/paludis" "paludisbuild,tty"
}

pkg_setup() {
	if ! built_with_use dev-libs/libpcre cxx ; then
		eerror "Paludis needs dev-libs/libpcre built with C++ support"
		eerror "Please build dev-libs/libpcre with USE=cxx support"
		die "Rebuild dev-libs/libpcre with USE=cxx"
	fi

	if use python-bindings && \
		! built_with_use --missing true dev-libs/boost python; then
		eerror "With USE python-bindings you need boost build with the python"
		eerror "use flag."
		die "Rebuild dev-libs/boost with USE python"
	fi

	if use pbins && \
		built_with_use app-arch/libarchive xattr; then
		eerror "With USE pbins you need libarchive build without the xattr"
		eerror "use flag."
		die "Rebuild app-arch/libarchive without USE xattr"
	fi

	if id paludisbuild >/dev/null 2>/dev/null ; then
		if ! groups paludisbuild | grep --quiet '\<tty\>' ; then
			eerror "The 'paludisbuild' user is now expected to be a member of the"
			eerror "'tty' group. You should add the user to this group before"
			eerror "upgrading Paludis."
			die "Please add paludisbuild to tty group"
		fi
	fi

	create-paludis-user

	# 'paludis' tries to exec() itself after an upgrade
	if [[ "${PKGMANAGER}" == paludis-0.[012345]* ]] && [[ -z "${CAVE}" ]] ; then
		eerror "The 'paludis' client has been removed in Paludis 0.60. You must use"
		eerror "'cave' to upgrade."
		die "Can't use 'paludis' to upgrade Paludis"
	fi
}

src_compile() {
	local repositories=`echo default unavailable unpackaged | tr -s \  ,`
	local environments=`echo default $(usev portage ) | tr -s \  ,`
	econf \
		$(use_enable doc doxygen ) \
		$(use_enable pbins ) \
		$(use_enable pink ) \
		$(use_enable ruby-bindings ruby ) \
		$(use ruby-bindings && use doc && echo --enable-ruby-doc ) \
		$(use_enable prebuilt-documentation ) \
		$(use_enable python-bindings python ) \
		$(use python-bindings && use doc && echo --enable-python-doc ) \
		$(use_enable vim-syntax vim ) \
		$(use_enable visibility ) \
		$(use_enable xml ) \
		$(use_enable search-index ) \
		$(use_enable test gtest ) \
		--with-vim-install-dir=/usr/share/vim/vimfiles \
		--with-repositories=${repositories} \
		--with-environments=${environments} \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS README NEWS

	BASHCOMPLETION_NAME="cave" dobashcomp bash-completion/cave

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins zsh-completion/_cave
	fi
}

src_test() {
	# Work around Portage bugs
	export PALUDIS_DO_NOTHING_SANDBOXY="portage sucks"
	export BASH_ENV=/dev/null

	if [[ `id -u` == 0 ]] ; then
		# hate
		export PALUDIS_REDUCED_UID=0
		export PALUDIS_REDUCED_GID=0
	fi

	if ! emake check ; then
		eerror "Tests failed. Looking for files for you to add to your bug report..."
		find "${S}" -type f -name '*.epicfail' -or -name '*.log' | while read a ; do
			eerror "    $a"
		done
		die "Make check failed"
	fi
}

pkg_postinst() {
	pm_is_paludis=false
	if [[ -f ${ROOT}/etc/env.d/50package-manager ]] ; then
		pm_is_paludis=$( source ${ROOT}/etc/env.d/50package-manager ; [[ ${PACKAGE_MANAGER} == paludis ]] && echo true || echo false )
	fi

	if ! $pm_is_paludis ; then
		elog "If you are using paludis or cave as your primary package manager,"
		elog "you should consider running:"
		elog "    eselect package-manager set paludis"
	fi
}
