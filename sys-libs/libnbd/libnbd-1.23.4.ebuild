# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit autotools bash-completion-r1 python-single-r1

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="NBD client library in userspace"
HOMEPAGE="https://gitlab.com/nbdkit/libnbd"
SRC_URI="https://download.libguestfs.org/libnbd/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE="examples fuse gnutls go ocaml python test"

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
BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${PN}-1.22.2-build-Remove-automagic-compiling-of-examples.patch"
	"${FILESDIR}/${PN}-1.22.2-Makefile.am-Conditionally-compile-some-SUBDIRS.patch"
	)

pkg_setup() {
	if use python; then
		python_setup
	fi
}

src_prepare() {
	default

	# Broken under sandbox.
	cat <<-EOF > lib/test-fork-safe-execvpe.sh || die
	#!/bin/sh
	:
	EOF

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable examples)
		$(use_enable fuse)
		$(use_enable go golang)
		$(use_enable ocaml)
		$(use_enable python)
		$(use_with gnutls)
		--disable-rust
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
