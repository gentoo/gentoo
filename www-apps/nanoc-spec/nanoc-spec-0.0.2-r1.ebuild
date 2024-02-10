# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

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
