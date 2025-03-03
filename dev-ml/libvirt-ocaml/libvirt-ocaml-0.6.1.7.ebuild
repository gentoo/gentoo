# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OCaml language binding for libvirt native C API"
HOMEPAGE="https://ocaml.libvirt.org/"
SRC_URI="https://download.libvirt.org/ocaml/ocaml-libvirt-${PV}.tar.gz"

S="${WORKDIR}/ocaml-libvirt-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-emulation/libvirt
	dev-lang/ocaml:=[ocamlopt]"
BDEPEND="dev-lang/perl
	 dev-ml/findlib[ocamlopt]
	 virtual/pkgconfig"
