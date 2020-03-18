# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils multilib

DESCRIPTION="OpenCL bindings for Erlang"
HOMEPAGE="https://github.com/tonyrog/cl"
SRC_URI="https://github.com/tonyrog/cl/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-lang/erlang-16
	virtual/opencl
	dev-util/rebar
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-${P}

src_compile() {
	rebar compile || die
}

src_install() {
	ERLANG_DIR="/usr/$(get_libdir)/erlang/lib"
	CL_DIR="${ERLANG_DIR}/${P}"
	insinto "${CL_DIR}"
	doins -r ebin src include c_src examples
}
