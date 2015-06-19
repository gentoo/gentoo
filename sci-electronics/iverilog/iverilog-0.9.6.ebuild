# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/iverilog/iverilog-0.9.6.ebuild,v 1.6 2014/03/12 10:09:35 ago Exp $

EAPI=4

inherit eutils multilib

DESCRIPTION="A Verilog simulation and synthesis tool"
SRC_URI="ftp://icarus.com/pub/eda/verilog/v${PV:0:3}/verilog-${PV}.tar.gz"
HOMEPAGE="http://iverilog.icarus.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="examples"

RDEPEND="app-arch/bzip2
	sys-libs/readline
	sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/verilog-${PV}"

src_prepare() {
	# Fix tests
	mkdir -p lib/ivl
	touch lib/ivl/ivl
	sed -i -e 's/driver\/iverilog -B./IVERILOG_ROOT="." driver\/iverilog -B./' Makefile.in || die

	# Fix LDFLAGS
	sed -i -e 's/@shared@/@shared@ $(LDFLAGS)/' {cadpli,tgt-vhdl,tgt-null,tgt-stub,tgt-vvp}/Makefile.in || die
}

src_install() {
	emake -j1 \
		prefix="${ED}"/usr \
		mandir="${ED}"/usr/share/man \
		infodir="${ED}"/usr/share/info \
		libdir="${ED}"/usr/$(get_libdir) \
		libdir64="${ED}"/usr/$(get_libdir) \
		vpidir="${ED}"/usr/$(get_libdir)/ivl \
		install

	dodoc *.txt
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
