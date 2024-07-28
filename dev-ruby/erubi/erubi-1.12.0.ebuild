# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_GEMSPEC="erubi.gemspec"

inherit ruby-fakegem

DESCRIPTION="a ERB template engine for ruby; a simplified fork of Erubis"
HOMEPAGE="https://github.com/jeremyevans/erubi"
SRC_URI="https://github.com/jeremyevans/erubi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"

ruby_add_bdepend "test? ( dev-ruby/minitest dev-ruby/minitest-global_expectations )"
