#Funkcja przyjmuje 2 liczby i wykonuje na nich jedno z 4 działań podstawowcyh, jeśli wybierzemy piąte, czyli potęgowanie zapyta do jakiej potęgi podnieść liczby
Function Calculate {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = "Wprowadź pierwszą liczbę: "
        )]
        [double]$liczba1, #zmienna przechowująca pierwszą liczbę

        [Parameter(
            Mandatory = $true,
            Position = 2,
            HelpMessage = "Wprowadź drugą liczbę: "
        )]
        [double]$liczba2, #zmienna przechowująca drugą liczbę

        [Parameter(
            Mandatory = $true,
            Position = 3,
            HelpMessage = "Wprowadź operator (+, -, *, /, p)"
        )]
        [ValidateSet("+", "-", "*", "/", "p")]
        [string]$operator #zmienna przechowująca operator
    )

    DynamicParam {
        #jeśli wybierzemy operator, który oznacza potęgowanie
        if ($operator -eq "p") {
            $nAttribute = New-Object System.Management.Automation.ParameterAttribute
            $nAttribute.Position = 4
            $nAttribute.Mandatory = $true
            $nAttribute.HelpMessage = "Do jakiej potęgi ma być podniesiona każda liczba: "
    
            $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($nAttribute)
    
            $nParam = New-Object System.Management.Automation.RuntimeDefinedParameter('n', [Int32], $attributeCollection)
    
            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('n', $nParam)
    
            return $paramDictionary
        }
    }

    begin {
        #obiekt n zdefiniowany wyżej nie jest widoczny globalnie, więc tutaj przypisujemy jego wartość do zmiennej $n, żeby używać jej w Process
        if ($PSBoundParameters.ContainsKey('n')) {
            $n = $PSBoundParameters.n
        }
    }

    Process {
        #switch, który wykonuje działania
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
                    Write-Error "Nie można dzielić przez 0!" -ErrorAction Stop
                }
                $wynik = $liczba1 / $liczba2 
                Write-Host "$liczba1 $operator $liczba2 = $wynik"
            }
            "p" {
                if ($n -lt 0) {
                    Write-Error "Potęga musi być liczbą nieujemną." -ErrorAction Stop
                }
            
                $wynik1 = [Math]::Pow($liczba1, $n)
                $wynik2 = [Math]::Pow($liczba2, $n)
            
                Write-Host "Pierwsza liczba do potęgi $n to: $wynik1"
                Write-Host "Druga liczba do potęgi $n to: $wynik2"
            }
            default {
                Write-Error "Błędny operator. Użyj jednego z tych: +, -, *, /, p" -ErrorAction Stop
            }
        }
    }
}
