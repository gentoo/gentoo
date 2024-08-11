# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A plaintext backend for hiera-eyaml"
HOMEPAGE="https://github.com/gtmtechltd/hiera-eyaml-plaintext"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
