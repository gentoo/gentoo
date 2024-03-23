# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYP=pytorch-rls-v${PV}
DESCRIPTION="Intel® Optimization for Chainer"
HOMEPAGE="https://github.com/intel/ideep"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/${MYP}.tar.gz
	-> ${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"/ideep-${MYP}

src_install() {
	doheader -r include/*
}
