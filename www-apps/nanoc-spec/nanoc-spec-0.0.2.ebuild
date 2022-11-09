# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

inherit ruby-fakegem

DESCRIPTION="Provides Nanoc::Spec, containing functionality for writing tests for Nanoc"
HOMEPAGE="https://nanoc.app/"
LICENSE="MIT"

KEYWORDS="~amd64 ~riscv"
SLOT="0"
IUSE="${IUSE} minimal"

ruby_add_rdepend "
	>=www-apps/nanoc-core-4.11.13:0
"
