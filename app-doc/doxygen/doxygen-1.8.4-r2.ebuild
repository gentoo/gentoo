# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/doxygen/doxygen-1.8.4-r2.ebuild,v 1.6 2015/04/08 07:30:32 mgorny Exp $

EAPI=4

PYTHON_COMPAT=( python2_7 )
inherit eutils fdo-mime flag-o-matic python-any-r1 qt4-r2 toolchain-funcs

DESCRIPTION="Documentation system for most programming languages"
HOMEPAGE="http://www.doxygen.org/"
SRC_URI="http://ftp.stack.nl/pub/users/dimitri/${P}.src.tar.gz
	http://dev.gentoo.org/~xarthisius/distfiles/doxywizard.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="debug doc dot qt4 latex sqlite elibc_FreeBSD userland_GNU"

#missing SerbianCyrilic, JapaneseEn, KoreanEn, Chinesetraditional

LANGS=(hy ar pt_BR ca zh cs de da eo es fa fi fr el hr hu id it ja ko lt mk
nl nb pl pt ro ru sl sk sr sv tr uk vi af)
for X in "${LANGS[@]}" ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="qt4? ( dev-qt/qtgui:4 )
	latex? ( app-text/texlive[extra] )
	dev-lang/perl
	virtual/libiconv
	media-libs/libpng
	app-text/ghostscript-gpl
	sqlite? ( dev-db/sqlite:3 )
	dot? (
		media-gfx/graphviz
		media-libs/freetype
	)"

DEPEND="sys-apps/sed
	sys-devel/flex
	sys-devel/bison
	doc? ( ${PYTHON_DEPS} )
	${RDEPEND}"

RESTRICT="mirror"
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
	echo ${f_langs// /,}
}

pkg_setup() {
	tc-export CC CXX
	use doc && python-any-r1_pkg_setup
}

src_prepare() {
	# use CFLAGS, CXXFLAGS, LDFLAGS
	export ECFLAGS="${CFLAGS}" ECXXFLAGS="${CXXFLAGS}" ELDFLAGS="${LDFLAGS}"

	sed -i.orig -e 's:^\(TMAKE_CFLAGS_RELEASE\t*\)= .*$:\1= $(ECFLAGS):' \
		-e 's:^\(TMAKE_CXXFLAGS_RELEASE\t*\)= .*$:\1= $(ECXXFLAGS):' \
		-e 's:^\(TMAKE_LFLAGS_RELEASE\s*\)=.*$:\1= $(ELDFLAGS):' \
		-e "s:^\(TMAKE_CXX\s*\)=.*$:\1= $(tc-getCXX):" \
		-e "s:^\(TMAKE_LINK\s*\)=.*$:\1= $(tc-getCXX):" \
		-e "s:^\(TMAKE_LINK_SHLIB\s*\)=.*$:\1= $(tc-getCXX):" \
		-e "s:^\(TMAKE_CC\s*\)=.*$:\1= $(tc-getCC):" \
		-e "s:^\(TMAKE_AR\s*\)=.*$:\1= $(tc-getAR) cqs:" \
		tmake/lib/{{linux,gnu,freebsd,netbsd,openbsd,solaris}-g++,macosx-c++,linux-64}/tmake.conf \
		|| die

	# Ensure we link to -liconv
	if use elibc_FreeBSD; then
		for pro in */*.pro.in */*/*.pro.in; do
		echo "unix:LIBS += -liconv" >> "${pro}"
		done
	fi

	# Call dot with -Teps instead of -Tps for EPS generation - bug #282150
	sed -i -e '/addJob("ps"/ s/"ps"/"eps"/g' src/dot.cpp || die

	# prefix search tools patch, plus OSX fixes
	epatch "${FILESDIR}"/${PN}-1.8.1-prefix-misc-alt.patch
	epatch "${FILESDIR}"/${PN}-1.8.3.1-empty-line-sigsegv.patch #454348

	# patches applied upstream
	epatch "${FILESDIR}"/${P}-libreoffice.patch \
		"${FILESDIR}"/${P}-infinite_loop.patch #474716

	# fix final DESTDIR issue
	sed -i.orig -e "s:\$(INSTALL):\$(DESTDIR)/\$(INSTALL):g" \
		-e "s/all: Makefile.doxywizard/all:/g" \
		addon/doxywizard/Makefile.in || die

	# fix pdf doc
	sed -i.orig -e "s:g_kowal:g kowal:" \
		doc/maintainers.txt || die

	sed -e "s/\$(DATE)/$(LC_ALL="C" LANG="C" date)/g" \
		-i Makefile.in || die #428280

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
	# set ./configure options (prefix, Qt based wizard, docdir)

	local my_conf="--shared --enable-langs $(get_langs)"

	if use debug ; then
		my_conf="${my_conf} --debug"
	else
		my_conf="${my_conf} --release "
	fi

	use qt4 && my_conf="${my_conf} --with-doxywizard"

	use sqlite && my_conf="${my_conf} --with-sqlite3"

	# On non GNU userland (e.g. BSD), configure script picks up make and bails
	# out because it is not GNU make, so we force the right value.
	use userland_GNU || my_conf="${my_conf} --make ${MAKE} --install install"

	export LINK="${QMAKE_LINK}"
	export LINK_SHLIB="${QMAKE_CXX}"

	if use qt4 ; then
		pushd addon/doxywizard &> /dev/null
		eqmake4 doxywizard.pro -o Makefile.doxywizard
		popd &> /dev/null
	fi

	./configure --prefix "${EPREFIX}/usr" ${my_conf} \
			|| die
}

src_compile() {

	emake CFLAGS+="${ECFLAGS}" CXXFLAGS+="${ECXXFLAGS}" \
		LFLAGS+="${ELDFLAGS}" all

	# generate html and pdf (if tetex in use) documents.
	# errors here are not considered fatal, hence the ewarn message
	# TeX's font caching in /var/cache/fonts causes sandbox warnings,
	# so we allow it.
	if use doc; then
		if ! use dot; then
			sed -i -e "s/HAVE_DOT               = YES/HAVE_DOT    = NO/" \
				{Doxyfile,doc/Doxyfile} \
				|| ewarn "disabling dot failed"
		fi
		if use latex; then
			addwrite /var/cache/fonts
			addwrite /var/cache/fontconfig
			addwrite /usr/share/texmf/fonts/pk
			addwrite /usr/share/texmf/ls-R
			make pdf || ewarn '"make pdf docs" failed.'
		else
			cp doc/Doxyfile doc/Doxyfile.orig
			cp doc/Makefile doc/Makefile.orig
			sed -i.orig -e "s/GENERATE_LATEX    = YES/GENERATE_LATEX    = NO/" \
				doc/Doxyfile
			sed -i.orig -e "s/@epstopdf/# @epstopdf/" \
				-e "s/@cp Makefile.latex/# @cp Makefile.latex/" \
				-e "s/@sed/# @sed/" doc/Makefile
			make docs || ewarn '"make docs" failed.'
		fi
	fi
}

src_install() {
	emake DESTDIR="${D}" MAN1DIR=share/man/man1 install

	if use qt4; then
		doicon "${DISTDIR}/doxywizard.png"
		make_desktop_entry doxywizard "DoxyWizard ${PV}" \
			"/usr/share/pixmaps/doxywizard.png" \
			"Development"
	fi

	dodoc INSTALL LANGUAGE.HOWTO README

	# pdf and html manuals
	if use doc; then
		dohtml -r html/*
		use latex && dodoc latex/doxygen_manual.pdf
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	elog
	elog "The USE flags qt4, doc, and latex will enable doxywizard, or"
	elog "the html and pdf documentation, respectively.  For examples"
	elog "and other goodies, see the source tarball.  For some example"
	elog "output, run doxygen on the doxygen source using the Doxyfile"
	elog "provided in the top-level source dir."
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
