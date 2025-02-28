# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_OPTIONAL=1
RUST_REQ_USE="rustfmt"
PYTHON_COMPAT=( python3_{10..13} )
inherit autotools bash-completion-r1 python-single-r1 rust

DESCRIPTION="NBD client library in userspace"
HOMEPAGE="https://gitlab.com/nbdkit/libnbd"
SRC_URI="https://download.libguestfs.org/libnbd/$(ver_cut 1-2)-stable/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE="examples fuse gnutls go ocaml python rust test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

# libxml2 - URI support
RDEPEND="
	dev-libs/libxml2
	examples? (	dev-libs/glib
			dev-libs/libev )
	fuse? ( sys-fs/fuse:3 )
	gnutls? ( net-libs/gnutls:= )
	go? ( dev-lang/go )
	ocaml? ( >=dev-lang/ocaml-4.03:=[ocamlopt] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	test? (	sys-block/nbdkit[gnutls?]
		net-libs/gnutls:=[tools]
		ocaml? ( dev-ml/findlib[ocamlopt] )
)
"
BDEPEND="dev-lang/perl
	rust? ( ${RUST_DEPEND} )"

pkg_setup() {
	if use rust; then
		rust_pkg_setup
	fi
	if use python; then
		python_setup
	fi
}

src_prepare() {
	default

	if ! use examples; then
		sed -i Makefile.am -e '/^[[:blank:]]*examples[[:blank:]]*\\$/d' || die
		sed -i Makefile.am -e '/^[[:blank:]]*ocaml\/examples[[:blank:]]*\\$/d' || die
		sed -i Makefile.am -e '/^[[:blank:]]*rust\/examples[[:blank:]]*\\$/d' || die
	fi
	if ! use fuse; then
		sed -i Makefile.am -e '/^[[:blank:]]*fuse[[:blank:]]*\\$/d' || die
	fi
	if ! use go; then
		sed -i Makefile.am -e '/^[[:blank:]]*golang[[:blank:]]*\\$/d' || die
	fi
	if ! use ocaml; then
		sed -i Makefile.am -e '/^[[:blank:]]*ocaml[[:blank:]]*\\$/d' || die
		sed -i Makefile.am -e '/^[[:blank:]]*ocaml\/tests[[:blank:]]*\\$/d' || die
	fi
	if ! use python; then
		sed -i Makefile.am -e '/^[[:blank:]]*python[[:blank:]]*\\$/d' || die
# sh tests not support if python binding not built
		sed -i Makefile.am -e '/^[[:blank:]]*sh[[:blank:]]*\\$/d' || die
	fi
	if ! use rust; then
		sed -i Makefile.am -e '/^[[:blank:]]*rust[[:blank:]]*\\$/d' ||die
	fi

	# Not in portage
	sed -i Makefile.am -e '/[[:blank:]]*ublk[[:blank:]]*\\$/d' || die

	# Broken under sandbox.
	cat <<-EOF > lib/test-fork-safe-execvpe.sh || die
	#!/bin/sh
	:
	EOF

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable fuse)
		$(use_enable go golang)
		$(use_enable ocaml)
		$(use_enable python)
		$(use_enable rust)
		$(use_with gnutls)
		--disable-ublk # Not in portage
		--with-libxml2
	)

	export bashcompdir="$(get_bashcompdir)"

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	use python && python_optimize
}
