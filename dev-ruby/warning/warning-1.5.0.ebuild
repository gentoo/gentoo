# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"
RUBY_FAKEGEM_GEMSPEC="warning.gemspec"

inherit ruby-fakegem

DESCRIPTION="Custom processing for warnings"

HOMEPAGE="https://github.com/jeremyevans/ruby-warning"
SRC_URI="https://github.com/jeremyevans/ruby-warning/archive/${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-${P}"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

ruby_add_bdepend "test? ( dev-ruby/minitest-global_expectations )"
