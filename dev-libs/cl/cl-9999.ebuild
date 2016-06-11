# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/esdl/esdl-1.2.ebuild,v 1.1 2013/02/12 14:41:54 george Exp $

EAPI=6
inherit eutils fixheadtails git-r3 multilib

DESCRIPTION="OpenCL bindings for Erlang"
HOMEPAGE="https://github.com/tonyrog/cl"
EGIT_REPO_URI="https://github.com/tonyrog/cl.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	>=dev-lang/erlang-16
	virtual/opencl
	dev-util/rebar
"
DEPEND="${RDEPEND}"

src_compile() {
	rebar compile || die
}

src_install() {
	addpredict /usr/$(get_libdir)/erlang/lib
	ERLANG_DIR="/usr/$(get_libdir)/erlang/lib"
	CL_DIR="${ERLANG_DIR}/${P}"

	insinto "${CL_DIR}"
	doins -r ebin src include c_src examples
}
