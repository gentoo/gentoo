# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/isabelle/isabelle-2012-r1.ebuild,v 1.2 2015/03/25 01:46:06 gienah Exp $

EAPI="5"

inherit eutils java-pkg-2 multilib versionator

MY_PN="Isabelle"
MY_PV=$(replace_all_version_separators '-')
MY_P="${MY_PN}${MY_PV}"

JEDIT_PV="20120414"
JEDIT_PN="jedit_build"
JEDIT_P="${JEDIT_PN}-${JEDIT_PV}"

DESCRIPTION="Isabelle is a generic proof assistant"
HOMEPAGE="http://www.cl.cam.ac.uk/research/hvg/isabelle/index.html"
SRC_URI="http://www.cl.cam.ac.uk/research/hvg/isabelle/dist/${MY_P}.tar.gz
		doc? ( http://dev.gentoo.org/~gienah/snapshots/${MY_P}-doc-src.tar.gz )
		pide? ( http://www4.in.tum.de/~wenzelm/test/${JEDIT_P}.tar.gz )"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
ALL_LOGICS="Pure FOL +HOL ZF CCL CTT Cube FOLP LCF Sequents"
IUSE="${ALL_LOGICS} doc graphbrowsing ledit readline pide +proofgeneral test"

#upstream says
#bash 2.x/3.x, Poly/ML 5.x, Perl 5.x,
#for document preparation: complete LaTeX
DEPEND=">=app-shells/bash-3.0:*
		>=dev-lang/polyml-5.4.1:=[-portable]
		>=dev-lang/perl-5.8.8-r2"

RDEPEND="dev-perl/libwww-perl
	sci-mathematics/sha1-polyml
	doc? (
		virtual/latex-base
		dev-tex/rail
	)
	proofgeneral? (
		app-emacs/proofgeneral
	)
	pide? (
		>=dev-lang/scala-2.8.2
	)
	ledit? (
		app-misc/ledit
	)
	readline? (
		app-misc/rlwrap
	)
	${DEPEND}"

S="${WORKDIR}"/Isabelle${MY_PV}
JEDIT_S="${WORKDIR}/${JEDIT_P}"
TARGETDIR="/usr/share/Isabelle"${MY_PV}
LIBDIR="/usr/"$(get_libdir)"/Isabelle"${MY_PV}

pkg_setup() {
	java-pkg-2_pkg_setup
	if ! use proofgeneral
	then
		ewarn "You have deselected the Proof General interface."
		ewarn "Only a text terminal will be installed."
		ewarn "Emerge Isabelle with the proofgeneral USE flag enabled"
		ewarn "to get the common interface, that most people want."
	fi
}

src_prepare() {
	java-pkg-2_src_prepare
	epatch "${FILESDIR}/${PN}-2012-gentoo-settings.patch"
	# http://article.gmane.org/gmane.science.mathematics.logic.isabelle.devel/2732
	epatch "${FILESDIR}/${PN}-2012-signal-handling.patch"
	# http://article.gmane.org/gmane.science.mathematics.logic.isabelle.devel/2780
	epatch "${FILESDIR}/${PN}-2012-redundant-equations-in-function-definitions-error.patch"
	polymlver=$(poly -v | cut -d' ' -f2)
	polymlarch=$(poly -v | cut -d' ' -f9 | cut -d'-' -f1)
	sed -e "s@5.4.0@${polymlver}@g" \
		-i "${S}/etc/settings" \
		|| die "Could not configure polyml version in etc/settings"
	sed -e "s@ML_HOME=\"/@ML_HOME=\"${ROOT}@" \
		-i "${S}/etc/settings" \
		|| die "Could not configure polyml ML_HOME in etc/settings"
	sed -e "s@x86_64@${polymlarch}@g" \
		-i "${S}/etc/settings" \
		|| die "Could not configure polyml arch in etc/settings"
	sed -e "s@PROOFGENERAL_HOME=\"/@PROOFGENERAL_HOME=\"${ROOT}@" \
		-i "${S}/etc/settings" \
		|| die "Could not configure PROOFGENERAL_HOME in etc/settings"
	sed -e "s@/usr/lib64/Isabelle${MY_PV}@${LIBDIR}@g" \
		-i "${S}/etc/settings" \
		|| die "Could not configure Isabelle lib directory in etc/settings"
	epatch "${FILESDIR}/${PN}-2012-graphbrowser.patch"
	epatch "${FILESDIR}/${PN}-2012-libsha1.patch"
	cat <<- EOF >> "${S}/etc/settings"

		ISABELLE_GHC="${ROOT}usr/bin/ghc"
		ISABELLE_OCAML="${ROOT}usr/bin/ocaml"
		ISABELLE_SWIPL="${ROOT}usr/bin/swipl"
		ISABELLE_JDK_HOME="\$(java-config --jdk-home)"
		SCALA_HOME="${ROOT}usr/share/scala"
		SHA1_HOME="/usr/$(get_libdir)/sha1-polyml"
	EOF
	if use pide; then
		cat <<- EOF >> "${S}/etc/settings"
			ISABELLE_JEDIT_BUILD_HOME="\$ISABELLE_HOME/${JEDIT_P}"
			init_component ${JEDIT_S}
		EOF
	fi
	if use ledit && ! use readline; then
		epatch "${FILESDIR}/${PN}-2012-reverse-line-editor-order.patch"
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
	if use pide; then
		pushd "${S}/src/Tools/jEdit" \
			|| die "Could not change directory to src/Tools/jEdit"
		"${S}"/bin/isabelle jedit -b -f \
			|| die "pide build failed"
		popd
		# The jedit_build stuff is only required to build
		# Isabelle/jEdit Prover IDE (PIDE).  These 2 lines need to be deleted
		# from etc/settings as the jedit_build source code is not installed
		sed -e '/ISABELLE_JEDIT_BUILD_HOME/d' \
			-e '/init_component/d' \
			-i "${S}/etc/settings" \
			|| die "Could not delete jedit_build lines from etc/settings"
	fi
}

src_test() {
	einfo "Running tests. A test run can take up to several hours!"
	./build -b -t || die "tests failed"
}

src_install() {
	exeinto ${TARGETDIR}/bin
	doexe bin/isabelle-process bin/isabelle

	insinto ${TARGETDIR}
	doins -r src
	doins -r lib

	docompress -x /usr/share/doc/${PF}
	dodoc -r doc
	if use doc; then
		dosym /usr/share/doc/${PF}/doc "${TARGETDIR}/doc"
		# The build of sci-mathematics/haskabelle with use doc requires
		# sci-mathematics/isabelle[doc?]. The haskabelle doc build requires
		# the doc-src directory stuff in the isabelle package.  Which is not
		# provided in the Isabelle 2012 src tarball.  So extract it from a
		# snapshot of the isabelle repo taken soon after the Isabelle 2012
		# release.
		doins -r doc-src
		for i in "./doc-src/IsarRef/showsymbols" \
			"./doc-src/TutorialI/Overview/LNCS/makeDemo" \
			"./doc-src/TutorialI/isa-index" \
			"./doc-src/sedindex"
		do
			exeinto $(dirname "${TARGETDIR}/${i}")
			doexe ${i}
		done
	fi

	for i in "./build" \
		"./src/Pure/mk" \
		"./src/Pure/build-jars" \
		"./src/Tools/JVM/build" \
		"./src/Tools/JVM/java_ext_dirs" \
		"./src/Tools/jEdit/lib/Tools/jedit" \
		"./src/Tools/Metis/fix_metis_license" \
		"./src/Tools/Metis/make_metis" \
		"./src/Tools/Metis/scripts/mlpp" \
		"./src/Tools/WWW_Find/lib/Tools/wwwfind" \
		"./src/Tools/Code/lib/Tools/codegen" \
		"./src/HOL/Mirabelle/lib/Tools/mirabelle" \
		"./src/HOL/Tools/Predicate_Compile/lib/scripts/swipl_version" \
		"./src/HOL/Tools/SMT/lib/scripts/remote_smt" \
		"./src/HOL/Tools/ATP/scripts/remote_atp" \
		"./src/HOL/Tools/ATP/scripts/spass" \
		"./src/HOL/Mutabelle/lib/Tools/mutabelle" \
		"./src/HOL/TPTP/TPTP_Parser/make_mlyacclib" \
		"./src/HOL/TPTP/TPTP_Parser/make_tptp_parser" \
		"./src/HOL/TPTP/lib/Tools/tptp_isabelle_demo" \
		"./src/HOL/TPTP/lib/Tools/tptp_graph" \
		"./src/HOL/TPTP/lib/Tools/tptp_isabelle_comp" \
		"./src/HOL/TPTP/lib/Tools/tptp_refute" \
		"./src/HOL/TPTP/lib/Tools/tptp_translate" \
		"./src/HOL/TPTP/lib/Tools/tptp_sledgehammer" \
		"./src/HOL/TPTP/lib/Tools/tptp_nitpick" \
		"./src/HOL/Library/Sum_of_Squares/neos_csdp_client" \
		"./src/HOL/IMP/export.sh" \
		"./lib/browser/build" \
		"./lib/Tools/tty" \
		"./lib/Tools/mkproject" \
		"./lib/Tools/keywords" \
		"./lib/Tools/browser" \
		"./lib/Tools/install" \
		"./lib/Tools/mkdir" \
		"./lib/Tools/unsymbolize" \
		"./lib/Tools/getenv" \
		"./lib/Tools/java" \
		"./lib/Tools/make" \
		"./lib/Tools/emacs" \
		"./lib/Tools/scala" \
		"./lib/Tools/print" \
		"./lib/Tools/latex" \
		"./lib/Tools/findlogics" \
		"./lib/Tools/doc" \
		"./lib/Tools/logo" \
		"./lib/Tools/usedir" \
		"./lib/Tools/yxml" \
		"./lib/Tools/version" \
		"./lib/Tools/makeall" \
		"./lib/Tools/scalac" \
		"./lib/Tools/document" \
		"./lib/Tools/env" \
		"./lib/Tools/display" \
		"./lib/Tools/dimacs2hol" \
		"./lib/scripts/keywords" \
		"./lib/scripts/unsymbolize" \
		"./lib/scripts/run-polyml" \
		"./lib/scripts/run-smlnj" \
		"./lib/scripts/feeder" \
		"./lib/scripts/yxml" \
		"./lib/scripts/polyml-version" \
		"./lib/scripts/process"
	do
		exeinto $(dirname "${TARGETDIR}/${i}")
		doexe ${i}
	done

	dodir /etc/isabelle
	insinto /etc/isabelle
	doins -r etc/*

	dosym /etc/isabelle "${TARGETDIR}/etc"
	dosym "${LIBDIR}/heaps" "${TARGETDIR}/heaps"

	insinto ${LIBDIR}
	doins -r heaps

	bin/isabelle install -d ${TARGETDIR} -p "${ED}usr/bin" \
		|| die "isabelle install failed"
	newicon lib/icons/isabelle.xpm "${PN}.xpm"
	dodoc ANNOUNCE CONTRIBUTORS COPYRIGHT NEWS README

	java-pkg_regjar \
		"${ED}${TARGETDIR}/src/Tools/JVM/java_ext_dirs.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/QuickNotepad.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/Console.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/ErrorList.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/Hyperlinks.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/SideKick.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/cobra.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/js.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/scala-compiler.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jars/Isabelle-jEdit.jar" \
		"${ED}${TARGETDIR}/src/Tools/jEdit/dist/jedit.jar" \
		"${ED}${TARGETDIR}/lib/classes/ext/scala-swing.jar" \
		"${ED}${TARGETDIR}/lib/classes/ext/scala-library.jar" \
		"${ED}${TARGETDIR}/lib/classes/ext/Pure.jar" \
		"${ED}${TARGETDIR}/lib/browser/GraphBrowser.jar"
}

pkg_postinst() {
	# If any of the directories in /etc/isabelle/components do not exist, then
	# even isabelle getenv ISABELLE_HOME fails.  Hence it is necessary to
	# to delete any non-existing directories.  If an old Isabelle version was
	# installed with component ebuilds like sci-mathematics/e, then the
	# Isabelle version is upgraded, then the contrib directories will not
	# exist initially, it is necessary to delete them from /etc/isabelle/components.
	# Then these components are rebuilt (creating these directories) using the
	# EAPI=5 subslot depends.
	for i in $(egrep '^[^#].*$' "${ROOT}etc/isabelle/components")
	do
		if [ ! -d /usr/share/Isabelle2012/${i} ]; then
			sed -e "\@${i}@d" -i "${ROOT}etc/isabelle/components"
		fi
	done
	if use ledit && use readline; then
		elog "Both readline and ledit use flags specified.  The default setting"
		elog "if both are installed is to use readline (rlwrap), this can be"
		elog "modfied by editing the ISABELLE_LINE_EDITOR setting in"
		elog "${ROOT}/etc/isabelle/settings"
	fi
	elog "Please ensure you have a pdf viewer installed, for example:"
	elog "As root: emerge app-text/zathura-pdf-poppler"
	elog "Please configure your preferred pdf viewer, something like:"
	elog "As normal user: xdg-mime default zathura.desktop application/pdf"
	elog "Or alternatively by editing the PDF_VIEWER variable in the system"
	elog "settings file ${ROOT}etc/isabelle/settings and/or the user"
	elog "settings file \$HOME/.isabelle/${MY_P}/etc/settings"
	elog "To improve sledgehammer performance, consider installing:"
	elog "USE=isabelle emerge sci-mathematics/e sci-mathematics/spass"
	elog "For nitpick it is necessary to install:"
	elog "emerge sci-mathematics/kodkodi"
}
