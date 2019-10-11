# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package toolchain-funcs java-pkg-opt-2 flag-o-matic

# from ftp://ftp.cstug.cz/pub/tex/local/tlpretest/archive/tex4ht.tar.xz
TL_TEX4HT_VER="2019-03-22"

# tex4ht-20050331_p2350 -> tex4ht-1.0.2005_03_31_2350
MY_P="${PN}-1.0.${PV:0:4}_${PV:4:2}_${PV:6:2}_${PV/*_p/}"

DESCRIPTION="Converts (La)TeX to (X)HTML, XML and OO.org"
HOMEPAGE="http://www.cse.ohio-state.edu/~gurari/TeX4ht/
	http://www.cse.ohio-state.edu/~gurari/TeX4ht/bugfixes.html"
SRC_URI="http://www.cse.ohio-state.edu/~gurari/TeX4ht/fix/${MY_P}.tar.gz
	mirror://gentoo/${PN}-texlive-${TL_TEX4HT_VER}.tar.xz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="java"

RDEPEND="app-text/ghostscript-gpl
	media-gfx/imagemagick
	dev-libs/kpathsea
	java? ( >=virtual/jre-1.5 )"

DEPEND="dev-libs/kpathsea"

BDEPEND="virtual/pkgconfig
	java? ( >=virtual/jdk-1.5 )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cp -a "${WORKDIR}/texmf-dist/"* texmf/ || die
	eapply_user
	cd "${S}/texmf/tex4ht/base/unix" || die
	sed -i \
		-e "s#~/tex4ht.dir#${EPREFIX}/usr/share#" \
		-e "s#tpath/tex/texmf/fonts/tfm/!#t${EPREFIX}/usr/share/texmf-dist/fonts/tfm/!\nt${EPREFIX}/usr/local/share/texmf/fonts/tfm/!\nt${EPREFIX}/var/cache/fonts/tfm/!\nt${EPREFIX}${TEXMF}/fonts/tfm/!#" \
		-e "s#%%~#${EPREFIX}${TEXMF}#g" \
		-e "s#/usr/share/texmf/#${EPREFIX}${TEXMF}/#" \
		tex4ht.env \
		|| die "sed of tex4ht.env failed"

	einfo "Removing precompiled java stuff"
	find "${S}" '(' -name '*.class' -o -name '*.jar' ')' -print -delete || die
}

src_compile() {
	has_version '>=dev-libs/kpathsea-6.2.1' \
		&& append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"

	cd "${S}/src" || die
	einfo "Compiling postprocessor sources..."
	for f in tex4ht t4ht htcmd ; do
		$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -o $f $f.c \
			-DENVFILE="\"${EPREFIX}${TEXMF}/tex4ht/base/tex4ht.env\"" \
			-DHAVE_DIRENT_H -DKPATHSEA -lkpathsea \
			|| die "Compiling $f failed"
	done
	if use java; then
		einfo "Compiling java files..."
		cd java || die
		ejavac *.java */*.java */*/*.java -d ../../texmf/tex4ht/bin
		cd "${S}/texmf/tex4ht/bin" || die
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
	dobin "${S}"/bin/unix/mk4ht

	# install the .4ht scripts
	insinto ${TEXMF}/tex/generic/tex4ht
	doins "${S}"/texmf/tex/generic/tex4ht/*

	# install the special htf fonts
	insinto ${TEXMF}/tex4ht
	doins -r "${S}/texmf/tex4ht/ht-fonts"

	if use java; then
		# install the java files
		doins -r "${S}/texmf/tex4ht/bin"
		java-pkg_jarinto ${TEXMF}/tex4ht/bin
		java-pkg_dojar "${S}/${PN}.jar"
	fi

	# install the .4xt files
	doins -r "${S}/texmf/tex4ht/xtpipes"

	# install the env file
	insinto ${TEXMF}/tex4ht/base
	newins "${S}/texmf/tex4ht/base/unix/tex4ht.env" tex4ht.env

	insinto /etc/texmf/texmf.d
	doins "${FILESDIR}/50tex4ht.cnf"

	insinto ${TEXMF}/tex/generic/${PN}
	insopts -m755
	doins "${S}"/bin/ht/unix/*
}

pkg_postinst() {
	use java ||	elog 'ODF converters (oolatex & friends) require the java use flag'
	latex-package_pkg_postinst
	elog "In order to avoid collisions with multiple packages"
	elog "We are not installing the scripts in /usr/bin anymore"
	elog "If you want to use, say, htlatex, you can use 'mk4ht htlatex file'"
}
