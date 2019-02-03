# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils check-reqs java-pkg-2 versionator

MY_PN="Isabelle"
MY_PV=$(replace_all_version_separators '-')
MY_P="${MY_PN}${MY_PV}"

BP_PV="1.2.1"
BP_PN="bash_process"
BP_P="${BP_PN}-${BP_PV}"
BP_IC_PN="${BP_PN}-isabelle-component"
BP_IC_P="${BP_IC_PN}-${BP_PV}"

# csdp is used in the compile of HOL_ex in
# Library/Sum_of_Squares/sos_wrapper.ML where it execs $ISABELLE_CSDP
CSDP_PV="6.x"
CSDP_PN="csdp"
CSDP_P="${CSDP_PN}-${CSDP_PV}"
CSDP_IC_PN="${CSDP_PN}-isabelle-component"
CSDP_IC_P="${CSDP_IC_PN}-${CSDP_PV}"

ISABELLE_FONTS_PV="20160830"
ISABELLE_FONTS_PN="isabelle_fonts"
ISABELLE_FONTS_P="${ISABELLE_FONTS_PN}-${ISABELLE_FONTS_PV}"
ISABELLE_FONTS_IC_PN="${ISABELLE_FONTS_PN}-isabelle-component"
ISABELLE_FONTS_IC_P="${ISABELLE_FONTS_IC_PN}-${ISABELLE_FONTS_PV}"

JEDIT_PV="20161024"
JEDIT_PN="jedit_build"
JEDIT_P="${JEDIT_PN}-${JEDIT_PV}"
JEDIT_IC_PN="${JEDIT_PN}-isabelle-component"
JEDIT_IC_P="${JEDIT_IC_PN}-${JEDIT_PV}"

JORTHO_PV="1.0-2"
JORTHO_PN="jortho"
JORTHO_P="${JORTHO_PN}-${JORTHO_PV}"
JORTHO_IC_PN="${JORTHO_PN}-isabelle-component"
JORTHO_IC_P="${JORTHO_IC_PN}-${JORTHO_PV}"

JFREECHART_PV="1.0.14-1"
JFREECHART_PN="jfreechart"
JFREECHART_P="${JFREECHART_PN}-${JFREECHART_PV}"
JFREECHART_IC_PN="${JFREECHART_PN}-isabelle-component"
JFREECHART_IC_P="${JFREECHART_IC_PN}-${JFREECHART_PV}"

POLYML_PV="5.6-1"
POLYML_PN="polyml"
POLYML_P="${POLYML_PN}-${POLYML_PV}"
POLYML_IC_PN="${POLYML_PN}-isabelle-component"
POLYML_IC_P="${POLYML_IC_PN}-${POLYML_PV}"

SSH_JAVA_PV="20161009"
SSH_JAVA_PN="ssh-java"
SSH_JAVA_P="${SSH_JAVA_PN}-${SSH_JAVA_PV}"
SSH_JAVA_IC_PN="${SSH_JAVA_PN}-isabelle-component"
SSH_JAVA_IC_P="${SSH_JAVA_IC_PN}-${SSH_JAVA_PV}"

XZ_JAVA_PV="1.5"
XZ_JAVA_PN="xz-java"
XZ_JAVA_P="${XZ_JAVA_PN}-${XZ_JAVA_PV}"
XZ_JAVA_IC_PN="${XZ_JAVA_PN}-isabelle-component"
XZ_JAVA_IC_P="${XZ_JAVA_IC_PN}-${XZ_JAVA_PV}"

SS="2.12"

DESCRIPTION="Isabelle is a generic proof assistant"
HOMEPAGE="http://www.cl.cam.ac.uk/research/hvg/Isabelle/index.html"
SRC_URI="http://isabelle.in.tum.de/website-${MY_P}/dist/${MY_P}.tar.gz
		http://isabelle.in.tum.de/dist/contrib/${BP_P}.tar.gz -> ${BP_IC_P}.tar.gz
		https://dev.gentoo.org/~gienah/snapshots/${CSDP_IC_P}.tar.gz
		http://isabelle.in.tum.de/dist/contrib/${ISABELLE_FONTS_P}.tar.gz -> ${ISABELLE_FONTS_IC_P}.tar.gz
		http://isabelle.in.tum.de/components/${JORTHO_P}.tar.gz -> ${JORTHO_IC_P}.tar.gz
		http://isabelle.in.tum.de/components/${JEDIT_P}.tar.gz -> ${JEDIT_IC_P}.tar.gz
		http://isabelle.in.tum.de/dist/contrib/${JFREECHART_P}.tar.gz -> ${JFREECHART_IC_P}.tar.gz
		https://dev.gentoo.org/~gienah/snapshots/${POLYML_IC_P}.tar.gz
		http://isabelle.in.tum.de/dist/contrib/${SSH_JAVA_P}.tar.gz -> ${SSH_JAVA_IC_P}.tar.gz
		https://dev.gentoo.org/~gienah/snapshots/${XZ_JAVA_IC_P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc graphbrowsing ledit readline"

#upstream says
#bash 2.x/3.x, Poly/ML 5.x, Perl 5.x,
#for document preparation: complete LaTeX
DEPEND=">=app-shells/bash-3.0:*
	>=dev-java/jcommon-1.0.18:1.0
	dev-java/jortho:0
	>=dev-java/jfreechart-1.0.14:1.0
	>=dev-java/itext-2.1.5:0
	dev-java/xz-java:0
	>=dev-lang/ghc-7.6.3
	>=dev-lang/polyml-5.6:=[-portable]
	>=dev-lang/perl-5.8.8-r2
	>=dev-lang/swi-prolog-6.6.6
	sci-libs/coinor-csdp
	=sci-mathematics/z3-4.4*[isabelle]
	>=virtual/jdk-1.8
	doc? (
		virtual/latex-base
		dev-tex/rail
	)
	dev-lang/scala:${SS}
	ledit? (
		app-misc/ledit
	)
	readline? (
		app-misc/rlwrap
	)"

RDEPEND="
	dev-perl/libwww-perl
	sci-mathematics/sha1-polyml
	>=virtual/jre-1.8"

S="${WORKDIR}"/Isabelle${MY_PV}
TARGETDIR="/usr/share/Isabelle"

# Notes on QA warnings: * Class files not found via DEPEND in package.env
# Stuff with $ in the name appear to be spurious:
# isabelle/Markup_Tree$$anonfun$results$1$1.class
# scala/tools/nsc/backend/jvm/GenJVM$BytecodeGenerator$$anonfun$computeLocalVarsIndex$1.class
# It wants javafx, I am unsure how to fix this. I test isabelle with the Sun JDK:
# javafx/application/Platform.class               javafx
# Presumably the user can provide the jEdit plugins if they are necessary:
# marker/MarkerSetsPlugin.class                   http://plugins.jedit.org/plugins/?MarkerSets
# projectviewer/gui/OptionPaneBase.class          http://plugins.jedit.org/plugins/?ProjectViewer

JAVA_GENTOO_CLASSPATH="itext,jcommon-1.0,jortho,jfreechart-1.0,scala-${SS},xz-java"

CHECKREQS_MEMORY="8192M"
CHECKREQS_DISK_BUILD="17G"
CHECKREQS_DISK_USR="8G"

src_unpack() {
	unpack "${MY_P}.tar.gz"
	cd "${S}/contrib" || die
	unpack ${BP_IC_P}.tar.gz
	unpack ${CSDP_IC_P}.tar.gz
	unpack ${ISABELLE_FONTS_IC_P}.tar.gz
	unpack ${JEDIT_IC_P}.tar.gz
	unpack ${JORTHO_IC_P}.tar.gz
	unpack ${JFREECHART_IC_P}.tar.gz
	unpack ${POLYML_IC_P}.tar.gz
	unpack ${SSH_JAVA_IC_P}.tar.gz
	unpack ${XZ_JAVA_IC_P}.tar.gz
}

pkg_setup() {
	java-pkg-2_pkg_setup
	check-reqs_pkg_setup
}

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_getjars ${JAVA_GENTOO_CLASSPATH}
	rm -rf "${S}/contrib/${BP_P}/{x86-cygwin,x86-darwin,x86_64-darwin,x86-linux,x86_64-linux}" \
		|| die "Could not remove bash_process binaries"
	rm -f "${S}/contrib/${JORTHI_P}/${JORTHO_PN}.jar" \
		|| die "Could not remove  contrib/${JORTHI_P}/${JORTHO_PN}.jar"
	eapply "${FILESDIR}/${PN}-2016-classpath.patch"
	eapply "${FILESDIR}/${PN}-2016-jfreechart-classpath.patch"
	eapply "${FILESDIR}/${PN}-2016.1-bash_process-1.2.1-settings.patch"
	eapply "${FILESDIR}/${PN}-2012-graphbrowser.patch"
	eapply "${FILESDIR}/${PN}-2016.1-libsha1.patch"
	eapply "${FILESDIR}/${PN}-2016.1-smt_timeout.patch"
	eapply "${FILESDIR}/${PN}-2016.1-smt_read_only_certificates.patch"
	eapply "${FILESDIR}/${PN}-2016.1-disable-jedit-build-after-install.patch"
	eapply "${FILESDIR}/${PN}-2016.1-jortho-1.0-2-classpath.patch"
	local polymlver=$(poly -v | cut -d' ' -f2)
	local polymlarch=$(poly -v | cut -d' ' -f9 | cut -d'-' -f1)
	cat <<- EOF >> "${S}/etc/settings"
		# Poly/ML Gentoo (${polymlarch,,})
		ML_PLATFORM=${polymlarch,,}-linux
		ML_HOME="${ROOT}usr/bin"
		ML_SYSTEM=polyml-${polymlver}
		ML_OPTIONS="-H 1000"
		ML_SOURCES="${ROOT}usr/src/debug/dev-lang/polyml-${polymlver}"

		ISABELLE_GHC="${ROOT}usr/bin/ghc"
		ISABELLE_OCAML="${ROOT}usr/bin/ocaml"
		ISABELLE_SWIPL="${ROOT}usr/bin/swipl"
		ISABELLE_JDK_HOME="\$(java-config --jdk-home)"
		ISABELLE_BUILD_JAVA_OPTIONS="-Djava.awt.headless=true"
		SCALA_HOME="${ROOT}usr/share/scala-${SS}"
		SHA1_HOME="${ROOT}usr/$(get_libdir)/sha1-polyml"
	EOF
	local Z3_P="$(best_version sci-mathematics/z3 | sed 's:sci-mathematics/::')"
	cat <<- EOF >> "${S}/etc/components"
		#bundled components
		contrib/${BP_P}
		contrib/${CSDP_P}
		contrib/${ISABELLE_FONTS_P}
		contrib/${JEDIT_P}
		contrib/${JORTHO_P}
		contrib/${JFREECHART_P}
		contrib/${POLYML_P}
		contrib/${SSH_JAVA_P}
		contrib/${XZ_JAVA_P}
		contrib/${Z3_P}
	EOF
	local Z3_RC="${ROOT}usr/share/Isabelle/contrib/${Z3_P}"
	[ -d "${Z3_RC}" ] \
		|| die "z3 isabelle component directory ${Z3_RC} does not exist"
	ln -s "${Z3_RC}" \
	   "${S}/contrib/${Z3_P}" \
		|| die "Failed to create z3 isabelle component symbolic link"
	if use ledit && ! use readline; then
		eapply "${FILESDIR}/${PN}-2012-reverse-line-editor-order.patch"
	fi
	rm -f "${S}/contrib/${JFREECHART_P}/lib"/*.jar \
		|| die "Could not rm bundled jar files supplied by Gentoo"
}

src_compile() {
	unset DISPLAY
	einfo "Building Isabelle. This may take some time."
	pushd contrib/${BP_P} || die "Could not cd to contrib/${BP_P}"
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -o ${BP_PN} ${BP_PN}.c \
		|| die "Could not build ${BP_PN}"
	popd || die
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
	popd || die
	./bin/isabelle build -a -b -s -v || die "isabelle build failed"
}

src_install() {
	local Z3_P="$(best_version sci-mathematics/z3 | sed 's:sci-mathematics/::')"
	rm "${S}/contrib/${Z3_P}" \
		|| die "Failed to remove z3 isabelle component symbolic link"

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

	for i in $(find \
		./{bin,lib,"contrib/${BP_P}/${BP_PN}",src/HOL,src/Pure,src/Tools} \
		-type f -executable -print)
	do
		exeinto $(dirname "${TARGETDIR}/${i}")
		doexe ${i}
	done

	insinto /etc/isabelle
	doins -r etc/*
	dosym /etc/isabelle "${TARGETDIR}/etc"

	local LIBDIR="/usr/"$(get_libdir)"/Isabelle"${MY_PV}
	dosym "${LIBDIR}/heaps" "${TARGETDIR}/heaps"
	insinto ${LIBDIR}
	doins -r heaps

	./bin/isabelle install -d ${TARGETDIR} "${ED}usr/bin" \
		|| die "isabelle install failed"
	newicon lib/icons/"${PN}.xpm" "${PN}.xpm"
	newicon lib/icons/"${PN}-mini.xpm" "${PN}-mini.xpm"

	java-pkg_regjar \
		$(find . -type f -name \*.jar -print | sed -e "s@^\.@${ED}${TARGETDIR}@g")

	local DOCS=( "ANNOUNCE" "CONTRIBUTORS" "COPYRIGHT" "NEWS" "README" )
	einstalldocs
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
		if [ ! -d ${TARGETDIR}/${i} ]; then
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
	elog "For nitpick it is necessary to install:"
	elog "emerge sci-mathematics/kodkodi"
}
