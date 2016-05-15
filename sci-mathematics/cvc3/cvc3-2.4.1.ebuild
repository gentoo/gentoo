# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit elisp-common

DESCRIPTION="CVC3 is a theorem prover for Satisfiability Modulo Theories (SMT) problems"
HOMEPAGE="http://www.cs.nyu.edu/acsys/cvc3/index.html"
SRC_URI="http://www.cs.nyu.edu/acsys/cvc3/releases/2.4.1/${P}.tar.gz"

LICENSE="BSD MIT HPND zchaff? ( zchaff )"
RESTRICT="mirror zchaff? ( bindist )"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs isabelle test zchaff"

RDEPEND="dev-libs/gmp:0=
		isabelle? (
			>=sci-mathematics/isabelle-2011.1-r1:=
		)"
DEPEND="${RDEPEND}
		doc? (
			app-doc/doxygen
			media-gfx/graphviz
		)
		emacs? (
			virtual/emacs
		)"

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	sed -e 's#prefix=@prefix@#prefix=$(patsubst %/,%,$(DESTDIR))@prefix@#' \
		-e 's#libdir=@libdir@#libdir=$(patsubst %/,%,$(DESTDIR))@libdir@#' \
		-e 's#mandir=@mandir@#mandir=$(patsubst %/,%,$(DESTDIR))@mandir@#' \
		-i "${S}/Makefile.local.in" \
		|| die "Could not set DESTDIR in Makefile.local.in"
}

src_configure() {
	# --enable-static disables building of shared libraries, statically
	# links /usr/bin/cvc3 and installs static libraries.
	# --enable-static --enable-sharedlibs behaves the same as just --enable-static
	econf \
		--enable-dynamic \
		$(use_enable zchaff)

	if use test; then
		sed -e 's@LD_LIBS = @LD_LIBS = -L'"${S}"'/lib -Wl,-R'"${S}"'/lib @' \
			-i "${S}/test/Makefile" \
			|| die "Could not set library paths in test/Makefile"
	fi
}

src_compile() {
	emake

	if use doc; then
		pushd doc || die "Could not cd to doc"
		emake
		popd
	fi

	if use emacs ; then
		pushd "${S}/emacs" || die "Could change directory to emacs"
		elisp-compile *.el || die "emacs elisp compile failed"
		popd
	fi

	if use test; then
		pushd test || die "Could not cd to test"
		emake
		popd
	fi
}

src_test() {
	pushd test || die "Could not cd to test"
	./bin/test || die "tests failed"
	popd
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		pushd "${S}"/doc/html || die "Could not cd to doc/html"
		dohtml *.html
		insinto /usr/share/doc/${PF}/html
		doins *.css *.gif *.png
		popd
	fi

	if use emacs ; then
		elisp-install ${PN} emacs/*.{el,elc}
		cp "${FILESDIR}"/${SITEFILE} "${S}"
		elisp-site-file-install ${SITEFILE}
	fi

	if use isabelle; then
		ISABELLE_HOME="$(isabelle getenv ISABELLE_HOME | cut -d'=' -f 2)" \
			|| die "isabelle getenv ISABELLE_HOME failed"
		[[ -n "${ISABELLE_HOME}" ]] || die "ISABELLE_HOME empty"
		dodir "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		cat <<- EOF >> "${S}/settings"
			CVC3_COMPONENT="\$COMPONENT"
			CVC3_HOME="${ROOT}usr/bin"
			CVC3_SOLVER="\$CVC3_HOME/cvc3"
			CVC3_REMOTE_SOLVER="cvc3"
			CVC3_INSTALLED="yes"
		EOF
		insinto "${ISABELLE_HOME}/contrib/${PN}-${PV}/etc"
		doins "${S}/settings"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	if use isabelle; then
		if [ -f "${ROOT}etc/isabelle/components" ]; then
			if egrep "contrib/${PN}-[0-9.]*" "${ROOT}etc/isabelle/components"; then
				sed -e "/contrib\/${PN}-[0-9.]*/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
			cat <<- EOF >> "${ROOT}etc/isabelle/components"
				contrib/${PN}-${PV}
			EOF
		fi
	fi
	if use zchaff; then
		einfo "This copy of CVC3 is also configured to use the SAT solver zchaff whose"
		einfo "copyright is owned by Princeton University and is more restrictive."
		einfo "Specifically, it may be used for internal, noncommercial, research purposes"
		einfo "only. See the copyright notices from the zchaff source files which are"
		einfo "included in the LICENSE file."
		einfo "To build CVC3 without these files, please build cvc3 without the zchaff"
		einfo "use flag (note: zchaff is disabled by default):"
		einfo "USE=-zchaff emerge sci-mathemathematics/cvc3"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	if use isabelle; then
		if [ ! -f "${ROOT}usr/bin/cvc3" ]; then
			if [ -f "${ROOT}etc/isabelle/components" ]; then
				# Note: this sed should only match the version of this ebuild
				# Which is what we want as we do not want to remove the line
				# of a new CVC3 being installed during an upgrade.
				sed -e "/contrib\/${PN}-${PV}/d" \
					-i "${ROOT}etc/isabelle/components"
			fi
		fi
	fi
}
