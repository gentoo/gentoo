# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/tex4ht/tex4ht-20090611_p1038-r3.ebuild,v 1.3 2015/07/12 18:15:04 zlogene Exp $

EAPI=4

inherit latex-package toolchain-funcs java-pkg-opt-2

IUSE=""

# tex4ht-20050331_p2350 -> tex4ht-1.0.2005_03_31_2350
MY_P="${PN}-1.0.${PV:0:4}_${PV:4:2}_${PV:6:2}_${PV/*_p/}"

DESCRIPTION="Converts (La)TeX to (X)HTML, XML and OO.org"
HOMEPAGE="http://www.cse.ohio-state.edu/~gurari/TeX4ht/
	http://www.cse.ohio-state.edu/~gurari/TeX4ht/bugfixes.html"
SRC_URI="http://www.cse.ohio-state.edu/~gurari/TeX4ht/fix/${MY_P}.tar.gz"

LICENSE="LPPL-1.2"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
SLOT="0"

DEPEND=">=sys-apps/sed-4
	java? ( >=virtual/jdk-1.5 )"

RDEPEND="app-text/ghostscript-gpl
	media-gfx/imagemagick
	java? ( >=virtual/jre-1.5 )"

IUSE="java"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-texlive-updates.patch"
	cd "${S}/texmf/tex4ht/base/unix"
	sed -i \
		-e "s#~/tex4ht.dir#${EPREFIX}/usr/share#" \
		-e "s#tpath/tex/texmf/fonts/tfm/!#t${EPREFIX}/usr/share/texmf-dist/fonts/tfm/!\nt${EPREFIX}/usr/local/share/texmf/fonts/tfm/!\nt${EPREFIX}/var/cache/fonts/tfm/!\nt${EPREFIX}${TEXMF}/fonts/tfm/!#" \
		-e "s#%%~/texmf-dist#${EPREFIX}${TEXMF}#g" \
		-e "s#/usr/share/texmf/#${EPREFIX}${TEXMF}/#" \
		tex4ht.env \
		|| die "sed of tex4ht.env failed"

	einfo "Removing precompiled java stuff"
	find "${S}" '(' -name '*.class' -o -name '*.jar' ')' -print -delete
}

src_compile() {
	cd "${S}/src/"
	einfo "Compiling postprocessor sources..."
	for f in tex4ht t4ht htcmd ; do
		$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -o $f $f.c \
			-DENVFILE="\"${EPREFIX}${TEXMF}/tex4ht/base/tex4ht.env\"" \
			-DHAVE_DIRENT_H -DKPATHSEA -lkpathsea \
			|| die "Compiling $f failed"
	done
	if use java; then
		einfo "Compiling java files..."
		cd java
		ejavac *.java */*.java */*/*.java -d ../../texmf/tex4ht/bin
		cd "${S}/texmf/tex4ht/bin"
		# Create the jar needed by oolatex
		jar -cf "${S}/${PN}.jar" * || die "failed to create jar"
	fi
}

src_install () {
	# install the binaries
	dobin "${S}/src/tex4ht" "${S}/src/t4ht" "${S}/src/htcmd"
	# install the scripts
	if ! use java; then
		rm -f "${S}"/bin/unix/oo*
		rm -f "${S}"/bin/unix/jh*
	fi
	dobin "${S}"/bin/unix/mk4ht || die

	# install the .4ht scripts
	insinto ${TEXMF}/tex/generic/tex4ht
	doins "${S}"/texmf/tex/generic/tex4ht/* || die

	# install the special htf fonts
	insinto ${TEXMF}/tex4ht
	doins -r "${S}/texmf/tex4ht/ht-fonts" || die

	if use java; then
		# install the java files
		doins -r "${S}/texmf/tex4ht/bin"
		java-pkg_jarinto ${TEXMF}/tex4ht/bin
		java-pkg_dojar "${S}/${PN}.jar"
	fi

	# install the .4xt files
	doins -r "${S}/texmf/tex4ht/xtpipes" || die

	# install the env file
	insinto ${TEXMF}/tex4ht/base
	newins "${S}/texmf/tex4ht/base/unix/tex4ht.env" tex4ht.env || die

	if latex-package_has_tetex_3 ; then
		insinto /etc/texmf/texmf.d
		doins "${FILESDIR}/50tex4ht.cnf" || die
	fi

	insinto ${TEXMF}/tex/generic/${PN}
	insopts -m755
	doins "${S}"/bin/ht/unix/* || die
}

pkg_postinst() {
	use java ||	elog 'ODF converters (oolatex & friends) require the java use flag'
	latex-package_pkg_postinst
	elog "In order to avoid collisions with multiple packages"
	elog "We are not installing the scripts in /usr/bin anymore"
	elog "If you want to use, say, htlatex, you can use 'mk4ht htlatex file'"
}
