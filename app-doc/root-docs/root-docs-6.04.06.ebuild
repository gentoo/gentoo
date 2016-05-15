# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

ROOT_PN="root"
ROOFIT_DOC_PV=2.91-33
ROOFIT_QS_DOC_PV=3.00
TMVA_DOC_PV=4.2.0

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib virtualx python-any-r1

DESCRIPTION="Documentation for ROOT Data Analysis Framework"
HOMEPAGE="https://root.cern.ch"
SRC_URI="https://root.cern.ch/download/${ROOT_PN}_v${PV}.source.tar.gz
	math? (
		http://tmva.sourceforge.net/docu/TMVAUsersGuide.pdf -> TMVAUsersGuide-v${TMVA_DOC_PV}.pdf
		https://root.cern.ch/download/doc/RooFit_Users_Manual_${ROOFIT_DOC_PV}.pdf
		http://root.cern.ch/drupal/sites/default/files/roofit_quickstart_${ROOFIT_QS_DOC_PV}.pdf )
	api? (
		${HOMEPAGE}/sites/default/files/images/root6-banner.jpg
		${HOMEPAGE}/sites/all/themes/newsflash/images/info.png )"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="api +math +metric http"

VIRTUALX_REQUIRED="api"

DEPEND="
	app-text/pandoc
	dev-haskell/pandoc-citeproc[bibutils]
	dev-texlive/texlive-latex
	virtual/pkgconfig
	api? (
		media-fonts/dejavu
		~sci-physics/root-${PV}[X,graphviz,opengl]
	)"
RDEPEND=""

DOC_DIR="/usr/share/doc/${ROOT_PN}-${PV}"

S="${WORKDIR}/${ROOT_PN}-${PV}"

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-6.00.01-makehtml.patch"

	# prefixify the configure script
	sed -i \
		-e "s:/usr:${EPREFIX}/usr:g" \
		configure || die "prefixify configure failed"
}

src_configure() {
	# we need only to setup paths here, html docs doesn't depend on USE flags
	if use api; then
		./configure \
			--prefix="${EPREFIX}/usr" \
			--etcdir="${EPREFIX}/etc/root" \
			--libdir="${EPREFIX}/usr/$(get_libdir)/${PN}" \
			--docdir="${EPREFIX}/usr/share/doc/${PF}" \
			--tutdir="${EPREFIX}/usr/share/doc/${PF}/examples/tutorials" \
			--testdir="${EPREFIX}/usr/share/doc/${PF}/examples/tests" \
			--with-llvm-config="${EPREFIX}/usr/bin/llvm-config" \
			--with-sys-iconpath="${EPREFIX}/usr/share/pixmaps" \
			--nohowto
	fi
}

src_compile() {
	pdf_target=( primer users-guide )
	local pdf_size=pdfa4
	use metric || pdf_size=pdfletter
	use math && pdf_target+=( minuit2 spectrum )
	use http && pdf_target+=( HttpServer JSROOT )

	local i
	for (( i=0; i<${#pdf_target[@]}; i++ )); do
		emake -C documentation/"${pdf_target[i]}" "${pdf_size}"
	done

	if use api; then
		# video drivers may want to access hardware devices
		cards=$(echo -n /dev/dri/card* /dev/ati/card* /dev/nvidiactl* | sed 's/ /:/g')
		[[ -n "${cards}" ]] && addpredict "${cards}"

		ROOTSYS="${S}" Xemake html
		# if root.exe crashes, return code will be 0 due to gdb attach,
		# so we need to check if last html file was generated;
		# this check is volatile and can't catch crash on the last file.
		[[ -f htmldoc/WindowAttributes_t.html ]] || die "html doc generation crashed"
	fi
}

src_install() {
	insinto "${DOC_DIR}"

	local i
	for (( i=0; i<${#pdf_target[@]}; i++ )); do
		doins documentation/"${pdf_target[i]}"/*.pdf
	done
	unset pdf_target

	use math && doins \
		"${DISTDIR}/RooFit_Users_Manual_${ROOFIT_DOC_PV}.pdf" \
		"${DISTDIR}/roofit_quickstart_${ROOFIT_QS_DOC_PV}.pdf" \
		"${DISTDIR}/TMVAUsersGuide-v${TMVA_DOC_PV}.pdf"

	if use api; then
		# Install offline replacements for online messages
		cp "${DISTDIR}"/{root6-banner.jpg,info.png} htmldoc/ || die "cp failed"
		# too large data to copy
		dodir "${DOC_DIR}/html"
		mv htmldoc/* "${ED}${DOC_DIR}/html/" || die
		docompress -x ${DOC_DIR}/html
	fi
}
