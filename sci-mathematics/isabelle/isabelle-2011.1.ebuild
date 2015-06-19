# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/isabelle/isabelle-2011.1.ebuild,v 1.3 2012/01/30 06:54:53 gienah Exp $

EAPI="4"

JAVA_PKG_OPT_USE="graphbrowsing"
inherit eutils java-pkg-opt-2 multilib versionator

MY_PN="Isabelle"
MY_PV=$(replace_all_version_separators '-')
MY_P="${MY_PN}${MY_PV}"

DESCRIPTION="Isabelle is a generic proof assistant"
HOMEPAGE="http://www.cl.cam.ac.uk/research/hvg/isabelle/index.html"
SRC_URI="http://www.cl.cam.ac.uk/research/hvg/isabelle/dist/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
ALL_LOGICS="Pure FOL +HOL ZF CCL CTT Cube FOLP LCF Sequents"
IUSE="${ALL_LOGICS} doc graphbrowsing +proofgeneral test"

#upstream says
#bash 2.x/3.x, Poly/ML 5.x, Perl 5.x,
#for document preparation: complete LaTeX
DEPEND=">=app-shells/bash-3.0
		>=dev-lang/polyml-5.4.1[-portable]
		>=dev-lang/perl-5.8.8-r2"

RDEPEND="doc? (
		virtual/latex-base
		dev-tex/rail
	)
	proofgeneral? (
		app-emacs/proofgeneral
	)
	${DEPEND}"

S="${WORKDIR}"/Isabelle${MY_PV}
TARGETDIR="/usr/share/Isabelle"${MY_PV}
LIBDIR="/usr/"$(get_libdir)"/Isabelle"${MY_PV}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	if ! use proofgeneral
	then
		ewarn "You have deselected the Proof General interface."
		ewarn "Only a text terminal will be installed."
		ewarn "Emerge Isabelle with the proofgeneral USE flag enabled"
		ewarn "to get the common interface, that most people want."
	fi
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	if use proofgeneral; then
		epatch "${FILESDIR}/${PN}-2011.1-proofgeneral-gentoo-path.patch"
		polymlver=$(poly -v | cut -d' ' -f2)
		polymlarch=$(poly -v | cut -d' ' -f9 | cut -d'-' -f1)
		sed -e "s@5.4.0@${polymlver}@g" \
			-i "${S}/etc/settings" \
			|| die "Could not configure polyml version in etc/settings"
		sed -e "s@x86_64@${polymlarch}@g" \
			-i "${S}/etc/settings" \
			|| die "Could not configure polyml arch in etc/settings"
	fi
	if use graphbrowsing; then
		epatch "${FILESDIR}/${PN}-2011.1-graphbrowser.patch"
	fi
}

src_compile() {
	LOGICS=""
	for l in "${ALL_LOGICS}"; do
		if has "${l/+/}"; then
			LOGICS="${LOGICS} ${l/+/}"
		fi
	done
	einfo "Building Isabelle logics ${LOGICS}. This may take some time."
	./build -b -i "${LOGICS}" || die "building logics failed"
	./bin/isabelle makeall || die "isabelle makeall failed"
	if use graphbrowsing
	then
		rm -f "${S}/lib/browser/GraphBrowser.jar" \
			|| die "failed cleaning graph browser directory"
		pushd "${S}/lib/browser" \
			|| die "Could not change directory to lib/browser"
		./build || die "failed building the graph browser"
		popd
	fi
}

src_test() {
	einfo "Running tests. A test run can take up to several hours!"
	./build -b -t || die "tests failed"
}

src_install() {
	exeinto ${TARGETDIR}/bin
	doexe bin/isabelle-process bin/isabelle

	exeinto ${TARGETDIR}
	doexe build

	insinto ${TARGETDIR}
	doins -r src
	dodoc -r doc

	dodir /etc/isabelle
	insinto /etc/isabelle
	doins -r etc/*

	dosym /etc/isabelle "${TARGETDIR}/etc"
	dosym "${LIBDIR}/heaps" "${TARGETDIR}/heaps"

	insinto ${LIBDIR}
	doins -r heaps

	# use cp to keep file attributes
	cp -R lib "${ED}${TARGETDIR}" || die "install lib failed"

	bin/isabelle install -d ${TARGETDIR} -p "${ED}usr/bin" \
		|| die "isabelle install failed"
	newicon lib/icons/isabelle.xpm "${PN}.xpm"
	dodoc ANNOUNCE CONTRIBUTORS COPYRIGHT NEWS README

	java-pkg_regjar \
		"${ED}${TARGETDIR}/lib/browser/GraphBrowser.jar" \
		"${ED}${TARGETDIR}/lib/classes/ext/Pure.jar" \
		"${ED}${TARGETDIR}/lib/classes/ext/scala-library.jar" \
		"${ED}${TARGETDIR}/lib/classes/ext/scala-swing.jar" \
		"${ED}${TARGETDIR}/lib/classes/java_ext_dirs.jar"
}

pkg_postinst() {
	elog "You will need to re-emerge Isabelle after emerging polyml."
	elog "Please configure your preferred pdf viewer by editing"
	elog "the PDF_VIEWER variable in the system settings file"
	elog "/etc/isabelle/settings and/or the user settings file"
	elog "\$HOME/.isabelle/${MY_P}/etc/settings"
}
