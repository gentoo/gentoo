# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils multilib toolchain-funcs

DESCRIPTION="Machine-learning library, written in simple C++"
HOMEPAGE="http://www.torch.ch/"
SRC_URI="http://www.torch.ch/archives/Torch${PV%.1}src.tgz
	doc? ( http://www.torch.ch/archives/Torch3doc.tgz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc examples"

S=${WORKDIR}/Torch${PV%.1}

TORCH_PACKAGES="convolutions datasets decoder distributions gradients kernels matrix nonparametrics speech"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-prll.patch
}

src_compile() {
	local shalldebug="OPT"
	use debug && shalldebug="DBG"
	# -malign-double makes no sense on a 64-bit arch
	use amd64 || extraflags="-malign-double"
	cp config/Makefile_options_Linux .
	sed -i \
		-e "s:^PACKAGES.*:PACKAGES = ${TORCH_PACKAGES}:" \
		-e "s:^DEBUG.*:DEBUG = ${shalldebug}:" \
		-e "s:^CFLAGS_OPT_FLOAT.*:CFLAGS_OPT_FLOAT = ${CXXFLAGS} -ffast-math ${extraflags} -fPIC:" \
		-e "s:g++:$(tc-getCXX):g" \
		Makefile_options_Linux || die

	emake || die "emake failed"
}

src_install() {
	dolib.a lib/*/*.a
	insinto /usr/include/torch
	for directory in core ${TORCH_PACKAGES}; do
		doins ${directory}/*.h
	done

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	use doc && dodoc "${WORKDIR}"/docs/*pdf \
		&& dohtml -r "${WORKDIR}"/docs/manual/*
}
