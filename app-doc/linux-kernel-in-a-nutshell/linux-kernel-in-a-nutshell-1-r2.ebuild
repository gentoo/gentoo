# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Linux Kernel in a Nutshell: A Desktop Quick Reference"
HOMEPAGE="http://www.kroah.com/lkn/"
SRC_URI="https://www.kernel.org/pub/linux/kernel/people/gregkh/lkn/lkn_pdf.tar.bz2
	https://www.kernel.org/pub/linux/kernel/people/gregkh/lkn/lkn_xml.tar.bz2"
S="${WORKDIR}"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

src_install() {
	docinto pdf
	dodoc -r lkn_pdf/*

	docinto xml
	dodoc -r lkn_xml/*
}
