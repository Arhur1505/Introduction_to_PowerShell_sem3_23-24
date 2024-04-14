#Funkcja przyjmuje 2 liczby i wykonuje na nich jedno z 4 dzialan podstawowcyh, jeśli wybierzemy piate, czyli potegowanie zapyta do jakiej potęgi podniesc liczby
Function Calculate {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = "Wprowadz pierwsza liczbe: "
        )]
        [double]$liczba1, #zmienna przechowująca pierwsza liczbe

        [Parameter(
            Mandatory = $true,
            Position = 2,
            HelpMessage = "Wprowadz druga liczbe: "
        )]
        [double]$liczba2, #zmienna przechowujaca druga liczbe

        [Parameter(
            Mandatory = $true,
            Position = 3,
            HelpMessage = "Wprowadz operator (+, -, *, /, p)"
        )]
        [ValidateSet("+", "-", "*", "/", "p")]
        [string]$operator #zmienna przechowujaca operator
    )

    DynamicParam {
        #jesli wybierzemy operator, który oznacza potegowanie
        if ($operator -eq "p") {
            $nAttribute = New-Object System.Management.Automation.ParameterAttribute
            $nAttribute.Position = 4
            $nAttribute.Mandatory = $true
            $nAttribute.HelpMessage = "Do jakiej potegi ma być podniesiona kazda liczba: "
    
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($nAttribute)
    
            $nParam = New-Object System.Management.Automation.RuntimeDefinedParameter('n', [Int32], $attributeCollection)
    
            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('n', $nParam)
    
            return $paramDictionary
        }
    }

    begin {
        #obiekt n zdefiniowany wyzej nie jest widoczny globalnie, więc tutaj przypisujemy jego wartosc do zmiennej $n, zeby uzywac jej w Process
        if ($PSBoundParameters.ContainsKey('n')) {
            $n = $PSBoundParameters.n
        }
    }

    Process {
        #switch, ktory wykonuje działania
        switch ($operator) {
            "+" { 
                $wynik = $liczba1 + $liczba2 
                Write-Host "$liczba1 $operator $liczba2 = $wynik"
            }
            "-" { 
                $wynik = $liczba1 - $liczba2 
                Write-Host "$liczba1 $operator $liczba2 = $wynik"
            }
            "*" { 
                $wynik = $liczba1 * $liczba2 
                Write-Host "$liczba1 $operator $liczba2 = $wynik"
            }
            "/" {
                if ($liczba2 -eq 0) {
                    Write-Error "Nie mozna dzielic przez 0!" -ErrorAction Stop
                }
                $wynik = $liczba1 / $liczba2 
                Write-Host "$liczba1 $operator $liczba2 = $wynik"
            }
            "p" {
                if ($n -lt 0) {
                    Write-Error "Potega musi być liczba nieujemna." -ErrorAction Stop
                }
            
                $wynik1 = [Math]::Pow($liczba1, $n)
                $wynik2 = [Math]::Pow($liczba2, $n)
            
                Write-Host "Pierwsza liczba do potegi $n to: $wynik1"
                Write-Host "Druga liczba do potegi $n to: $wynik2"
            }
            default {
                Write-Error "Bledny operator. Uzyj jednego z tych: +, -, *, /, p" -ErrorAction Stop
            }
        }
    }
}
