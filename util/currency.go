package util

const (
	USD = "USD"
	EUR = "EUR"
	RU  = "RU"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, EUR, RU:
		return true
	}
	return false
}
