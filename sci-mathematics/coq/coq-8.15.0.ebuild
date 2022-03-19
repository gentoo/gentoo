# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop dune

MY_PV=${PV/_p/pl}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Proof assistant written in O'Caml"
HOMEPAGE="http://coq.inria.fr/"
SRC_URI="https://github.com/coq/coq/archive/V${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk debug +ocamlopt"  # doc add when antlr & antlr-python are ready
RESTRICT="test"  # fails

RDEPEND="
	dev-ml/zarith:=
	|| (
		dev-ml/num
		<dev-lang/ocaml-4.09.0[ocamlopt?]
	)
	gtk? (
		dev-ml/lablgtk:3=[sourceview,ocamlopt?]
		dev-ml/lablgtk-sourceview:3=[ocamlopt?]
	)
"
DEPEND="${RDEPEND}"
# to build docs we needantlr >=4.7, not yet in the tree
# BDEPEND="doc? (
#	>=dev-java/antlr-4.7:4
#	dev-python/antlr-python:4
#	dev-python/beautifulsoup4
#	dev-python/pexpect
#	dev-python/sphinx_rtd_theme
#	dev-python/sphinxcontrib-bibtex
# )"

DOCS=( CODE_OF_CONDUCT.md CONTRIBUTING.md CREDITS INSTALL.md README.md )

src_configure() {
	local myconf=(
		-prefix /usr
		-libdir /usr/$(get_libdir)/coq
		-mandir /usr/share/man
		-docdir /usr/share/doc/${PF}
		-datadir /usr/share/coq
		-configdir /etc/xdg/${PN}
		# -with-doc $(usex doc)
		-with-doc no
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

	# use doc && emake DESTDIR="${D}" install-doc-all
	einstalldocs

	# Dune installs into /usr/<libdir>/ocaml/<coq> but
	# Coq wants /usr/<libdir>/<coq> ; symlink those directories
	for sym in ${syms[@]} ; do
		dosym $(ocamlc -where)/${sym} /usr/$(get_libdir)/${sym}
	done
}
