# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SLOT="0"
DESCRIPTION="The Gnus Newsreader and Mailreader"
XEMACS_PKG_CAT="standard"

XEMACS_EXPERIMENTAL="true"

RDEPEND="app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/xemacs-eterm
app-xemacs/sh-script
app-xemacs/net-utils
app-xemacs/os-utils
app-xemacs/dired
app-xemacs/mh-e
app-xemacs/sieve
app-xemacs/ps-print
app-xemacs/w3
app-xemacs/pgg
app-xemacs/mailcrypt
app-xemacs/ecrypto
app-xemacs/sasl
"
KEYWORDS="~alpha amd64 ppc ppc64 ~riscv sparc x86"

inherit xemacs-packages
