# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

inherit ruby-fakegem

DESCRIPTION="Provides Nanoc::Spec, containing functionality for writing tests for Nanoc"
HOMEPAGE="https://nanoc.app/"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="${IUSE} minimal"

ruby_add_rdepend "
	>=www-apps/nanoc-core-4.11.13:0
"
