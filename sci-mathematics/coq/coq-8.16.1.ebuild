# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_p/pl}
MY_P=${PN}-${MY_PV}

inherit desktop dune

DESCRIPTION="Proof assistant written in O'Caml"
HOMEPAGE="http://coq.inria.fr/"
SRC_URI="https://github.com/coq/coq/archive/V${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc gtk debug +ocamlopt"
RESTRICT="test"  # fails

RDEPEND="
	dev-ml/zarith:=
	|| (
		dev-ml/num
		<dev-lang/ocaml-4.09.0[ocamlopt?]
	)
	gtk? (
		>=dev-ml/lablgtk-3.1.2:3=[sourceview,ocamlopt?]
		>=dev-ml/lablgtk-sourceview-3.1.2:3=[ocamlopt?]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		>=dev-java/antlr-4.7:4
		dev-python/antlr4-python3-runtime
		dev-python/beautifulsoup4
		dev-python/pexpect
		dev-python/sphinx-rtd-theme
		dev-python/sphinxcontrib-bibtex
		dev-tex/latexmk
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-xetex
		media-fonts/freefont
	)
"

DOCS=( CODE_OF_CONDUCT.md CONTRIBUTING.md CREDITS INSTALL.md README.md )

src_configure() {
	local myconf=(
		-prefix /usr
		-libdir /usr/$(get_libdir)/coq
		-mandir /usr/share/man
		-docdir /usr/share/doc/${PF}
		-datadir /usr/share/coq
		-configdir /etc/xdg/${PN}
		-with-doc $(usex doc)
	)

	use debug && myconf+=( -debug )
	use ocamlopt || myconf+=( -byte-only )

	if use gtk ; then
		if use ocamlopt ; then
			myconf+=( -coqide opt )
		else
			myconf+=( -coqide byte )
		fi
	else
		myconf+=( -coqide no )
	fi

	export CAML_LD_LIBRARY_PATH="${S}/kernel/byterun/"

	echo "Configure options: ${myconf[@]}"
	sh ./configure ${myconf[@]} || die "configure failed"
}

src_compile() {
	emake STRIP="true" VERBOSE=1 COQ_USE_DUNE="" world
}

src_test() {
	emake STRIP="true" VERBOSE=1 COQ_USE_DUNE="" check
}

src_install() {
	local sym
	local syms=( coq-core coqide-server )

	emake STRIP="true" VERBOSE=1 COQ_USE_DUNE="" DESTDIR="${D}" install-library
	dune-install coq-core coqide-server

	if use gtk ; then
		dune-install coqide
		make_desktop_entry "coqide" "Coq IDE" "${EPREFIX}/usr/share/coq/coq.png"
		syms+=( coqide )
	fi

	use doc && emake DESTDIR="${D}" install-doc-all
	einstalldocs

	# Dune installs into /usr/<libdir>/ocaml/<coq> but
	# Coq wants /usr/<libdir>/<coq> ; symlink those directories
	for sym in ${syms[@]} ; do
		dosym $(ocamlc -where)/${sym} /usr/$(get_libdir)/${sym}
	done
}

pkg_preinst() {
	# bug https://bugs.gentoo.org/910236
	if has_version "sci-mathematics/coq:0/8.12.0" && [[ ! -L /usr/lib64/coq ]]
	then
		einfo "Removing colliding directory from version 8.12: /usr/lib64/coq"
		rm -rf /usr/lib64/coq
	fi
}
