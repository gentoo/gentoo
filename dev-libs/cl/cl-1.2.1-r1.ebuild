# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/esdl/esdl-1.2.ebuild,v 1.1 2013/02/12 14:41:54 george Exp $

EAPI=6
inherit eutils multilib

DESCRIPTION="OpenCL bindings for Erlang"
HOMEPAGE="https://github.com/tonyrog/cl"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"

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

src_prepare() {
	sed -i -e "s|git|\"${PV}\"|" src/cl.app.src || die

	eapply_user
}

src_compile() {
	rebar compile || die
}

src_install() {
	ERLANG_DIR="/usr/$(get_libdir)/erlang/lib"
	CL_DIR="${ERLANG_DIR}/${P}"
	insinto "${CL_DIR}"
	doins -r ebin src include c_src examples
}
