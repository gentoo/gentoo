# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils check-reqs java-pkg-2 multilib versionator

MY_PN="Isabelle"
MY_PV=$(replace_all_version_separators '-')
MY_P="${MY_PN}${MY_PV}"

# csdp is used in the compile of HOL_ex in
# Library/Sum_of_Squares/sos_wrapper.ML where it execs $ISABELLE_CSDP
CSDP_PV="6.x"
CSDP_PN="csdp"
CSDP_P="${CSDP_PN}-${CSDP_PV}"
CSDP_IC_PN="${CSDP_PN}-isabelle-component"
CSDP_IC_P="${CSDP_IC_PN}-${CSDP_PV}"

# exec_process is used in the compile of HOL-Mirabelle-ex, Codegen, etc.
EXEC_PROCESS_PV="1.0.3"
EXEC_PROCESS_PN="exec_process"
EXEC_PROCESS_P="${EXEC_PROCESS_PN}-${EXEC_PROCESS_PV}"
EXEC_PROCESS_IC_PN="${EXEC_PROCESS_PN}-isabelle-component"
EXEC_PROCESS_IC_P="${EXEC_PROCESS_IC_PN}-${EXEC_PROCESS_PV}"

JEDIT_PV="20150228"
JEDIT_PN="jedit_build"
JEDIT_P="${JEDIT_PN}-${JEDIT_PV}"
JEDIT_IC_PN="${JEDIT_PN}-isabelle-component"
JEDIT_IC_P="${JEDIT_IC_PN}-${JEDIT_PV}"

JFREECHART_PV="1.0.14-1"
JFREECHART_PN="jfreechart"
JFREECHART_P="${JFREECHART_PN}-${JFREECHART_PV}"
JFREECHART_IC_PN="${JFREECHART_PN}-isabelle-component"
JFREECHART_IC_P="${JFREECHART_IC_PN}-${JFREECHART_PV}"

POLYML_PV="5.5.2-3"
POLYML_PN="polyml"
POLYML_P="${POLYML_PN}-${POLYML_PV}"
POLYML_IC_PN="${POLYML_PN}-isabelle-component"
POLYML_IC_P="${POLYML_IC_PN}-${POLYML_PV}"

XZ_JAVA_PV="1.5"
XZ_JAVA_PN="xz-java"
XZ_JAVA_P="${XZ_JAVA_PN}-${XZ_JAVA_PV}"
XZ_JAVA_IC_PN="${XZ_JAVA_PN}-isabelle-component"
XZ_JAVA_IC_P="${XZ_JAVA_IC_PN}-${XZ_JAVA_PV}"

SS="2.11"

DESCRIPTION="Isabelle is a generic proof assistant"
HOMEPAGE="http://www.cl.cam.ac.uk/research/hvg/Isabelle/index.html"
SRC_URI="http://isabelle.in.tum.de/dist/${MY_P}.tar.gz
		http://dev.gentoo.org/~gienah/snapshots/${CSDP_IC_P}.tar.gz
		http://dev.gentoo.org/~gienah/snapshots/${EXEC_PROCESS_IC_P}.tar.gz
		http://isabelle.in.tum.de/components/${JEDIT_P}.tar.gz -> ${JEDIT_IC_P}.tar.gz
		http://isabelle.in.tum.de/dist/contrib/${JFREECHART_P}.tar.gz -> ${JFREECHART_IC_P}.tar.gz
		http://dev.gentoo.org/~gienah/snapshots/${POLYML_IC_P}.tar.gz
		http://dev.gentoo.org/~gienah/snapshots/${XZ_JAVA_IC_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc graphbrowsing ledit readline proofgeneral"

#upstream says
#bash 2.x/3.x, Poly/ML 5.x, Perl 5.x,
#for document preparation: complete LaTeX
DEPEND=">=app-shells/bash-3.0:*
	>=dev-java/jcommon-1.0.18:1.0
	>=dev-java/jfreechart-1.0.14:1.0
	>=dev-java/itext-2.1.5:0
	dev-java/xz-java:0
	>=dev-lang/ghc-7.6.3
	>=dev-lang/polyml-5.5.2:=[-portable]
	>=dev-lang/perl-5.8.8-r2
	dev-lang/swi-prolog
	sci-libs/coinor-csdp
	=virtual/jdk-1.7*
	doc? (
		virtual/latex-base
		dev-tex/rail
	)
	>=dev-lang/scala-2.11.6:${SS}
	ledit? (
		app-misc/ledit
	)
	readline? (
		app-misc/rlwrap
	)"

RDEPEND="dev-perl/libwww-perl
	sci-mathematics/sha1-polyml
	>=virtual/jre-1.7
	proofgeneral? (
		>=app-emacs/proofgeneral-4.1
	)
	${DEPEND}"

S="${WORKDIR}"/Isabelle${MY_PV}
CSDP_S="${WORKDIR}/${CSDP_P}"
EXEC_PROCESS_S="${WORKDIR}/${EXEC_PROCESS_P}"
JEDIT_S="${WORKDIR}/${JEDIT_P}"
JFREECHART_S="${WORKDIR}/${JFREECHART_P}"
XZ_JAVA_S="${WORKDIR}/${XZ_JAVA_P}"
TARGETDIR="/usr/share/Isabelle"${MY_PV}
LIBDIR="/usr/"$(get_libdir)"/Isabelle"${MY_PV}

# Notes on QA warnings: * Class files not found via DEPEND in package.env
# Stuff with $ in the name appear to be spurious:
# isabelle/Markup_Tree$$anonfun$results$1$1.class
# scala/tools/nsc/backend/jvm/GenJVM$BytecodeGenerator$$anonfun$computeLocalVarsIndex$1.class
# It wants javafx, I am unsure how to fix this. I test isabelle with the Sun JDK:
# javafx/application/Platform.class               javafx
# Presumably the user can provide the jEdit plugins if they are necessary:
# marker/MarkerSetsPlugin.class                   http://plugins.jedit.org/plugins/?MarkerSets
# projectviewer/gui/OptionPaneBase.class          http://plugins.jedit.org/plugins/?ProjectViewer

LIBRARY_PKGS="itext,jcommon-1.0,jfreechart-1.0,scala-${SS},xz-java"

CHECKREQS_MEMORY="8192M"
CHECKREQS_DISK_BUILD="35G"
CHECKREQS_DISK_USR="17G"

src_unpack() {
	unpack "${MY_P}.tar.gz"
	cd "${S}/contrib" || die
	unpack ${CSDP_IC_P}.tar.gz
	unpack ${EXEC_PROCESS_IC_P}.tar.gz
	unpack ${JEDIT_IC_P}.tar.gz
	unpack ${JFREECHART_IC_P}.tar.gz
	unpack ${POLYML_IC_P}.tar.gz
	unpack ${XZ_JAVA_IC_P}.tar.gz
}

pkg_setup() {
	java-pkg-2_pkg_setup
	check-reqs_pkg_setup
}

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_getjars ${LIBRARY_PKGS}
	epatch "${FILESDIR}/${PN}-2013-gentoo-settings.patch"
	epatch "${FILESDIR}/${PN}-2015-classpath.patch"
	epatch "${FILESDIR}/${PN}-2015-jfreechart-classpath.patch"
	polymlver=$(poly -v | cut -d' ' -f2)
	polymlarch=$(poly -v | cut -d' ' -f9 | cut -d'-' -f1)
	sed -e "s@5.5.0@${polymlver}@g" \
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
	# this example fails to compile with swi-prolog 6.5.2, so patch it so that
	# Isabelle will build, then reverse the patch so that the user can see the
	# original code.
	epatch "${FILESDIR}/${PN}-2013.2-HOL-Predicate_Compile_Examples.patch"
	cat <<- EOF >> "${S}/etc/settings"

		ISABELLE_GHC="${ROOT}usr/bin/ghc"
		ISABELLE_OCAML="${ROOT}usr/bin/ocaml"
		ISABELLE_SWIPL="${ROOT}usr/bin/swipl"
		ISABELLE_JDK_HOME="\$(java-config --jdk-home)"
		SCALA_HOME="${ROOT}usr/share/scala-${SS}"
		SHA1_HOME="/usr/$(get_libdir)/sha1-polyml"
	EOF
	cat <<- EOF >> "${S}/etc/components"
		#bundled components
		contrib/${CSDP_P}
		contrib/${EXEC_PROCESS_P}
		contrib/${JEDIT_P}
		contrib/${JFREECHART_P}
		contrib/${POLYML_P}
		contrib/${XZ_JAVA_P}
	EOF
	if use ledit && ! use readline; then
		epatch "${FILESDIR}/${PN}-2012-reverse-line-editor-order.patch"
	fi
	rm -f "${S}/contrib/jfreechart-1.0.14-1/lib/jcommon-1.0.18.jar" \
		"${S}/contrib/jfreechart-1.0.14-1/lib/jfreechart-1.0.14.jar" \
		"${S}/contrib/jfreechart-1.0.14-1/lib/iText-2.1.5.jar" \
		|| die "Could not rm bundled jar files supplied by Gentoo"
}

src_compile() {
	einfo "Building Isabelle. This may take some time."
	pushd contrib/${EXEC_PROCESS_P} || die "Could not cd to contrib/${EXEC_PROCESS_P}"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${EXEC_PROCESS_PN} ${EXEC_PROCESS_PN}.c \
		|| die "Could not build ${EXEC_PROCESS_PN}"
	popd
	if use graphbrowsing
	then
		rm -f "${S}/lib/browser/GraphBrowser.jar" \
			|| die "failed cleaning graph browser directory"
		pushd "${S}/lib/browser" \
			|| die "Could not change directory to lib/browser"
		./build || die "failed building the graph browser"
		popd
	fi
	./bin/isabelle jedit -b -f || die "pide build failed"
	pushd "${S}"/src/Pure || die "Could not change directory to src/Pure"
	../../bin/isabelle env ./build-jars -f || die "build-jars failed"
	popd
	./bin/isabelle build -a -b -s -v || die "isabelle build failed"
	epatch --reverse "${FILESDIR}/${PN}-2013.2-HOL-Predicate_Compile_Examples.patch"
}

src_install() {
	insinto ${TARGETDIR}
	doins -r src
	doins -r lib
	doins -r contrib
	doins ROOTS

	docompress -x /usr/share/doc/${PF}
	dodoc -r doc
	if use doc; then
		dosym /usr/share/doc/${PF}/doc "${TARGETDIR}/doc"
		# The build of sci-mathematics/haskabelle with use doc requires
		# sci-mathematics/isabelle[doc?]. The haskabelle doc build requires
		# the src/Doc directory stuff in the isabelle package.
		doins -r src/Doc
		for i in $(find ./src/Doc -type f -executable -print)
		do
			exeinto $(dirname "${TARGETDIR}/${i}")
			doexe ${i}
		done
	fi

	for i in $(find ./{bin,lib,src/HOL,src/Pure,src/Tools} -type f -executable -print)
	do
		exeinto $(dirname "${TARGETDIR}/${i}")
		doexe ${i}
	done

	insinto /etc/isabelle
	doins -r etc/*
	dosym /etc/isabelle "${TARGETDIR}/etc"

	dosym "${LIBDIR}/heaps" "${TARGETDIR}/heaps"
	insinto ${LIBDIR}
	doins -r heaps

	./bin/isabelle install -d ${TARGETDIR} "${ED}usr/bin" \
		|| die "isabelle install failed"
	newicon lib/icons/"${PN}.xpm" "${PN}.xpm"
	newicon lib/icons/"${PN}-mini.xpm" "${PN}-mini.xpm"
	dodoc ANNOUNCE CONTRIBUTORS COPYRIGHT NEWS README

	java-pkg_regjar \
		$(find . -type f -name \*.jar -print | sed -e "s@^\.@${ED}${TARGETDIR}@g")
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
		if [ ! -d /usr/share/${MY_P}/${i} ]; then
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
