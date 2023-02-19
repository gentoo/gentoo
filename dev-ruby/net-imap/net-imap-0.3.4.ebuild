# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="net-imap.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby client api for Internet Message Access Protocol"
HOMEPAGE="https://github.com/ruby/net-imap"
SRC_URI="https://github.com/ruby/net-imap/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://www.rfc-editor.org/rfc/rfc3454.txt )"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "
	dev-ruby/date
	dev-ruby/net-protocol
"

ruby_add_bdepend "test? ( dev-ruby/digest dev-ruby/strscan )"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's/__FILE__/"'${RUBY_FAKEGEM_GEMSPEC}'"/' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	if use test ; then
		mkdir rfcs || die
		cp "${DISTDIR}/rfc3454.txt" rfcs/ || die
	fi
}
