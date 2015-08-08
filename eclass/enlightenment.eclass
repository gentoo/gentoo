# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: enlightenment.eclass
# @MAINTAINER:
# enlightenment@gentoo.org
# @BLURB: simplify enlightenment package management

if [[ -z ${_ENLIGHTENMENT_ECLASS} ]]; then
_ENLIGHTENMENT_ECLASS=1

inherit eutils libtool

# @ECLASS-VARIABLE: E_PYTHON
# @DEFAULT_UNSET
# @DESCRIPTION:
# if defined, the package is based on Python/distutils

# @ECLASS-VARIABLE: E_CYTHON
# @DEFAULT_UNSET
# @DESCRIPTION:
# if defined, the package is Cython bindings (implies E_PYTHON)

# @ECLASS-VARIABLE: E_ECONF
# @DESCRIPTION:
# Array of flags to pass to econf (obsoletes MY_ECONF)
E_ECONF=()

# E_STATE's:
#	release      [default]
#		KEYWORDS arch
#		SRC_URI  $P.tar.gz
#		S        $WORKDIR/$P
#
#	snap         $PV has .200##### datestamp or .### counter
#		KEYWORDS ~arch
#		SRC_URI  $P.tar.bz2
#		S        $WORKDIR/$P
#
#	live         $PV has a 9999 marker
#		KEYWORDS ""
#		SRC_URI  svn/etc... up
#		S        $WORKDIR/$E_S_APPEND
#
# Overrides:
#	KEYWORDS    EKEY_STATE
#	SRC_URI     EURI_STATE
#	S           EURI_STATE

E_LIVE_SERVER_DEFAULT_SVN="http://svn.enlightenment.org/svn/e/trunk"
E_LIVE_SERVER_DEFAULT_GIT="git://git.enlightenment.org"

E_STATE="release"
if [[ ${PV} == *9999* ]] ; then
	if [[ ${EGIT_URI_APPEND} ]] ; then
		E_LIVE_SERVER=${E_LIVE_SERVER:-${E_LIVE_SERVER_DEFAULT_GIT}}
		EGIT_URI_APPEND=${EGIT_URI_APPEND:-${PN}}
		EGIT_PROJECT="enlightenment/${EGIT_SUB_PROJECT}/${EGIT_URI_APPEND}"
		EGIT_REPO_URI=${EGIT_SERVER:-${E_LIVE_SERVER_DEFAULT_GIT}}/${EGIT_SUB_PROJECT}/${EGIT_URI_APPEND}.git
		E_S_APPEND=${EGIT_URI_APPEND}
		E_LIVE_SOURCE="git"
		inherit git-2
	else
		E_LIVE_SERVER=${E_LIVE_SERVER:-${E_LIVE_SERVER_DEFAULT_SVN}}

		ESVN_URI_APPEND=${ESVN_URI_APPEND:-${PN}}
		ESVN_PROJECT="enlightenment/${ESVN_SUB_PROJECT}"
		ESVN_REPO_URI=${ESVN_SERVER:-${E_LIVE_SERVER_DEFAULT_SVN}}/${ESVN_SUB_PROJECT}/${ESVN_URI_APPEND}
		E_S_APPEND=${ESVN_URI_APPEND}
		E_LIVE_SOURCE="svn"
		inherit subversion
	fi
	E_STATE="live"
	WANT_AUTOTOOLS="yes"

elif [[ -n ${E_SNAP_DATE} ]] ; then
	E_STATE="snap"
else
	E_STATE="release"
fi

# Parse requested python state
: ${E_PYTHON:=${E_CYTHON}}
if [[ -n ${E_PYTHON} ]] ; then
	PYTHON_DEPEND="2"

	inherit python
fi

if [[ ${WANT_AUTOTOOLS} == "yes" ]] ; then
	WANT_AUTOCONF=${E_WANT_AUTOCONF:-latest}
	WANT_AUTOMAKE=${E_WANT_AUTOMAKE:-latest}
	inherit autotools
fi

ENLIGHTENMENT_EXPF="src_unpack src_compile src_install"
case "${EAPI:-0}" in
2|3|4|5) ENLIGHTENMENT_EXPF+=" src_prepare src_configure" ;;
*) ;;
esac
EXPORT_FUNCTIONS ${ENLIGHTENMENT_EXPF}

DESCRIPTION="A DR17 production"
HOMEPAGE="http://www.enlightenment.org/"
if [[ -z ${SRC_URI} ]] ; then
	case ${EURI_STATE:-${E_STATE}} in
	release) SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz";;
	snap)    SRC_URI="http://download.enlightenment.org/snapshots/${E_SNAP_DATE}/${P}.tar.bz2";;
	live)    SRC_URI="";;
	esac
fi

LICENSE="BSD"
SLOT="0"
case ${EKEY_STATE:-${E_STATE}} in
	release) KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-interix ~x86-solaris ~x64-solaris";;
	snap)    KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-interix ~x86-solaris ~x64-solaris";;
	live)    KEYWORDS="";;
esac
IUSE="nls doc"

DEPEND="doc? ( app-doc/doxygen )
	${E_PYTHON:+>=dev-python/setuptools-0.6_rc9}
	${E_CYTHON:+>=dev-python/cython-0.12.1}"
RDEPEND="nls? ( sys-devel/gettext )"

case ${EURI_STATE:-${E_STATE}} in
	release) S=${WORKDIR}/${P};;
	snap)    S=${WORKDIR}/${P};;
	live)    S=${WORKDIR}/${E_S_APPEND};;
esac

enlightenment_src_unpack() {
	if [[ ${E_STATE} == "live" ]] ; then
		case ${E_LIVE_SOURCE} in
			svn) subversion_src_unpack;;
			git) git-2_src_unpack;;
			*)   die "eek!";;
		esac
	else
		unpack ${A}
	fi
	if ! has src_prepare ${ENLIGHTENMENT_EXPF} ; then
		cd "${S}" || die
		enlightenment_src_prepare
	fi
}

enlightenment_src_prepare() {
	epatch_user
	[[ -s gendoc ]] && chmod a+rx gendoc
	if [[ ${WANT_AUTOTOOLS} == "yes" ]] ; then
		[[ -d po ]] && eautopoint -f
		# autotools require README, when README.in is around, but README
		# is created later in configure step
		[[ -f README.in ]] && touch README
		export SVN_REPO_PATH=${ESVN_WC_PATH}
		eautoreconf
	fi
	epunt_cxx
	elibtoolize
}

enlightenment_src_configure() {
	# gstreamer sucks, work around it doing stupid stuff
	export GST_REGISTRY="${S}/registry.xml"
	has static-libs ${IUSE} && E_ECONF+=( $(use_enable static-libs static) )

	econf ${MY_ECONF} "${E_ECONF[@]}"
}

enlightenment_src_compile() {
	has src_configure ${ENLIGHTENMENT_EXPF} || enlightenment_src_configure

	V=1 emake || die

	if use doc ; then
		if [[ -x ./gendoc ]] ; then
			./gendoc || die
		elif emake -j1 -n doc >&/dev/null ; then
			V=1 emake doc || die
		fi
	fi
}

enlightenment_src_install() {
	V=1 emake install DESTDIR="${D}" || die
	find "${D}" '(' -name CVS -o -name .svn -o -name .git ')' -type d -exec rm -rf '{}' \; 2>/dev/null
	for d in AUTHORS ChangeLog NEWS README TODO ${EDOCS}; do
		[[ -f ${d} ]] && dodoc ${d}
	done
	use doc && [[ -d doc ]] && dohtml -r doc/*
	if has static-libs ${IUSE} ; then
		use static-libs || find "${D}" -name '*.la' -exec rm -f {} +
	fi
}

fi
