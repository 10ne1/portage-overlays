# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/i8kutils/i8kutils-1.42.ebuild,v 1.3 2015/05/17 15:03:53 Ionel A $

EAPI=5

inherit systemd toolchain-funcs

DESCRIPTION="Dell Inspiron and Latitude utilities"
HOMEPAGE="https://launchpad.net/i8kutils"
SRC_URI="https://launchpad.net/i8kutils/trunk/${PV}/+download/${P/-/_}.tar.xz"

S="${WORKDIR}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="examples tk"

DEPEND="tk? ( dev-lang/tk )"
RDEPEND="${DEPEND} sys-power/acpi"

DOCS=( README.i8kutils )

src_prepare() {
	sed \
		-e '/^CC/d' \
		-e '/^CFLAGS/d' \
		-e 's: -g : $(LDFLAGS) :g' \
		-i Makefile || die

	tc-export CC
}

src_install() {
	dobin i8kctl i8kfan
	doman i8kctl.1

	use examples && dodoc -r examples

	newinitd "${S}"/debian/i8kutils.i8kmon.init i8k

	if use tk; then
		dobin i8kmon
		doman i8kmon.1
		dodoc i8kmon.conf
		systemd_dounit "${FILESDIR}"/i8kmon.service
	else
		cat >> "${ED}"/etc/conf.d/i8k <<- EOF
		# i8kmon disabled because the package was installed without USE=tk
		NOMON=1
		EOF
	fi

}
