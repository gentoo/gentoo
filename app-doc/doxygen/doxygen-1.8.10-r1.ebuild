# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit cmake-utils eutils fdo-mime flag-o-matic python-any-r1 qt4-r2
if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/doxygen/doxygen.git"
	SRC_URI=""
	KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
else
	SRC_URI="http://ftp.stack.nl/pub/users/dimitri/${P}.src.tar.gz"
	KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
fi
SRC_URI+=" https://dev.gentoo.org/~xarthisius/distfiles/doxywizard.png"

DESCRIPTION="Documentation system for most programming languages"
HOMEPAGE="http://www.doxygen.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="clang debug doc dot doxysearch latex qt4 sqlite userland_GNU"

#missing SerbianCyrilic, JapaneseEn, KoreanEn, Chinesetraditional
LANGS=(hy ar pt_BR ca zh cs de da eo es fa fi fr el hr hu id it ja ko lt mk
nl nb pl pt ro ru sl sk sr sv tr uk vi af)
for X in "${LANGS[@]}" ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="app-text/ghostscript-gpl
	dev-lang/perl
	media-libs/libpng
	virtual/libiconv
	clang? ( sys-devel/clang )
	dot? (
		media-gfx/graphviz
		media-libs/freetype
	)
	doxysearch? ( =dev-libs/xapian-1.2* )
	latex? ( app-text/texlive[extra] )
	qt4? ( dev-qt/qtgui:4 )
	sqlite? ( dev-db/sqlite:3 )
	"

REQUIRED_USE="doc? ( latex )"

DEPEND="sys-apps/sed
	sys-devel/flex
	sys-devel/bison
	doc? ( ${PYTHON_DEPS} )
	${RDEPEND}"

# src_test() defaults to make -C testing but there is no such directory (bug #504448)
RESTRICT="mirror test"
EPATCH_SUFFIX="patch"

get_langs() {
	# using only user set linguas also fixes #263641
	my_linguas=()
	for lingua in ${LINGUAS}; do
		if has ${lingua} "${LANGS[@]}"; then
			case ${lingua} in
				hy) lingua=am ;;
			    pt_BR) lingua=br ;;
				zh*) lingua=cn ;;
				cs) lingua=cz ;;
				da) lingua=dk ;;
				el*) lingua=gr ;;
				ja*) lingua=jp ;;
				ko) lingua=kr ;;
				nb) lingua=no ;;
				sl) lingua=si ;;
			    tr*) lingua=tr ;;
			    uk) lingua=ua ;;
			    af) lingua=za ;;
			esac
			has ${lingua} "${my_linguas[@]}" ||
				my_linguas+=(${lingua})
		fi
	done
	f_langs="${my_linguas[@]}"
	echo ${f_langs// /;}
}

pkg_setup() {
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	# Ensure we link to -liconv
	if use elibc_FreeBSD && has_version dev-libs/libiconv || use elibc_uclibc; then
		for pro in */*.pro.in */*/*.pro.in; do
		echo "unix:LIBS += -liconv" >> "${pro}"
		done
	fi

	# Call dot with -Teps instead of -Tps for EPS generation - bug #282150
	sed -i -e '/addJob("ps"/ s/"ps"/"eps"/g' src/dot.cpp || die

	epatch "${FILESDIR}"/${PN}-1.8.9.1-empty-line-sigsegv.patch #454348
	epatch "${FILESDIR}"/${P}-fix_flex_check.patch #567018

	epatch "${FILESDIR}"/${P}-link_with_pthread.patch

	# fix pdf doc
	sed -i.orig -e "s:g_kowal:g kowal:" \
		doc/maintainers.txt || die

	if is-flagq "-O3" ; then
		echo
		ewarn "Compiling with -O3 is known to produce incorrectly"
		ewarn "optimized code which breaks doxygen."
		echo
		elog "Continuing with -O2 instead ..."
		echo
		replace-flags "-O3" "-O2"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DDOC_INSTALL_DIR="share/doc/${P}"
		-DLANG_CODES="$(get_langs)"
		$(cmake-utils_use clang use_libclang)
		$(cmake-utils_use doc build_doc)
		$(cmake-utils_use doxysearch build_search)
		$(cmake-utils_use qt4 build_wizard)
		$(cmake-utils_use sqlite use_sqlite3)
		)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	# generate html and pdf documents. errors here are not considered
	# fatal, hence the ewarn message TeX's font caching in /var/cache/fonts
	# causes sandbox warnings, so we allow it.
	if use doc; then
		if ! use dot; then
			sed -i -e "s/HAVE_DOT               = YES/HAVE_DOT    = NO/" \
				{Doxyfile,doc/Doxyfile} \
				|| ewarn "disabling dot failed"
		fi
		cd "${BUILD_DIR}" && emake docs
	fi
}

src_install() {
	if use qt4; then
		doicon "${DISTDIR}/doxywizard.png"
		make_desktop_entry doxywizard "DoxyWizard ${PV}" \
			"/usr/share/pixmaps/doxywizard.png" \
			"Development"
	fi

	dodoc LANGUAGE.HOWTO README.md

	cmake-utils_src_install
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	elog
	elog "For examples and other goodies, see the source tarball. For some"
	elog "example output, run doxygen on the doxygen source using the"
	elog "Doxyfile provided in the top-level source dir."
	elog
	elog "Disabling the dot USE flag will remove the GraphViz dependency,"
	elog "along with Doxygen's ability to generate diagrams in the docs."
	elog "See the Doxygen homepage for additional helper tools to parse"
	elog "more languages."
	elog
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
